#!/usr/bin/php  
<?php  

require('config.php');
require('ambiente.php');
include('twitter.php');

if ($ambiente != 0) {
    $log = date("D, d/m/Y, H:i:s")."\n";
}

$twitter = new Twitter($key, $secret);


$bots = mysql_query("SELECT * FROM bots");


while ($bot = mysql_fetch_assoc($bots)) {
    $twitter->setOAuthToken($bot['tw_token']);
    $twitter->setOAuthTokenSecret($bot['tw_secret']);
    $ciudad_indice = $bot['ciudad_indice'];
    $palabra_indice = $bot['palabra_indice'];
    $cantidad_seguidos = $bot['siguiendo'];

    $palabras = mysql_query("SELECT * FROM palabras WHERE bot_id = '{$bot['id']}'");

    $arrayPalabras = array();
    $index = 1;
    while ($palabra = mysql_fetch_assoc($palabras)) {
        $arrayPalabras[$index] = $palabra['palabra'];
        $index ++;
    }
    $cantidad_palabras = count($arrayPalabras);
    mysql_query("UPDATE bots SET palabra_maximo = $cantidad_palabras WHERE id = '{$bot['id']}';");
    if ($ambiente != 0) {
        print_r($arrayPalabras);
    }

    $ciudades = mysql_query("SELECT * FROM ciudads AS ciu JOIN bot_ciudads AS bot ON ciu.id = bot.ciudad_id WHERE bot.bot_id = '{$bot['id']}';");

    $arrayCiudades = array();
    $index = 1;
    while ($ciudad = mysql_fetch_assoc($ciudades)) {
        $arrayCiudades[$index]['nombre'] = $ciudad['nombre'];
        $arrayCiudades[$index]['longitud'] = $ciudad['longitud'];
        $arrayCiudades[$index]['latitud'] = $ciudad['latitud'];
        $arrayCiudades[$index]['km'] = $ciudad['km'];
        $index ++;
    }
    $cantidad_ciudades = count($arrayCiudades);

    if ($ciudad_indice >= $cantidad_ciudades) {
        $ciudad_indice = 1;
    } else {
        $ciudad_indice++;
    }

    mysql_query("UPDATE bots SET ciudad_indice = $ciudad_indice WHERE id = '{$bot['id']}'");

    $geo = $arrayCiudades[$ciudad_indice]['longitud']. ',' .$arrayCiudades[$ciudad_indice]['latitud']. ',' .$arrayCiudades[$ciudad_indice]['km'] . 'km';
    if ($ambiente != 0) {
        echo $geo . "\n";
    }

    $encontrados = array();
    $seguir = true;
    $recorrido = true;

    while ($recorrido == true) {

        if ($palabra_indice > $cantidad_palabras) {
            $palabra_indice = 1;
            $recorrido = false;
        }
    
        $query = $arrayPalabras[$palabra_indice];
        
        $pagina = 1;
        $seguir = true;
        
        while ($seguir == true) {
            try {
                if ($ambiente != 0) {
                    echo "Pagina: " . $pagina . "\n";
                }
                $buscados = $twitter->search($query, null, null, 100, $pagina, null, null, $geo, true, null);

                if (!empty($buscados['results'])) {
                    foreach ($buscados['results'] as $usuarios) {
                        try {
                            $qry = mysql_query("SELECT * FROM tweets WHERE bot_id = '{$bot['id']}' AND tw_usuario_id = '{$usuarios['from_user_id']}'");

                            $continuar = true;
                            while($row = mysql_fetch_assoc($qry)) {
                                $continuar = false;
                                mysql_query("UPDATE tweets SET tw_tweet_id = '{$usuarios['id']}' WHERE id = '{$row['id']}';");
                            }

                            if ($continuar) {
                                $qry = mysql_query("SELECT * FROM tweets WHERE tw_tweet_id = '{$usuarios['id']}'");

                                while($row = mysql_fetch_assoc($qry)) {
                                    $continuar = false;
                                }
                            }

                            if ($continuar) {


                                $coincidencia = true;

    //                            foreach ($secundarias as $palabra) {
    //                                if (strpos($usuarios['text'], $palabra) != false) {
    //                                    $coincidencia = true;
    //                                }
    //                            }

                                if ($coincidencia) {

                                    if (!isset($usuarios['location'])) {
                                        $usuarios['location'] = "";
                                    }

                                    $query_insert = "INSERT INTO tweets (bot_id, tw_usuario_id, estado, tw_tweet_id, tw_location, tw_text, tw_created_at, tw_usuario, created_at, updated_at, palabra) VALUES ('" . $bot['id'] . "', '" . $usuarios['from_user_id'] . "', '0', '" . $usuarios['id'] . "', '" . $usuarios['location'] . "', '" . $usuarios['text'] . "', '" . $usuarios['created_at'] . "', '" . $usuarios['from_user'] . "', '" .  date("Y-m-d H:i:s") . "', '" . date("Y-m-d H:i:s") . "', '$query');";

                                    mysql_query($query_insert);
                                    $id = mysql_insert_id();

                                    try {
                                        $seguido = $twitter->friendshipsExists($usuarios['from_user'], $bot['tw_cuenta']);
                                        if ($ambiente != 0) {
                                            echo "Seguido: " . $seguido . "\n";
                                        }
                                        if ($seguido != 1) {
                                            
                                            $siguiendo = $twitter->friendshipsExists($bot['tw_cuenta'], $usuarios['from_user']);
                                            if ($siguiendo != 1) {
                                                $twitter->friendshipsCreate($usuarios['from_user_id']);
                                                mysql_query("UPDATE tweets SET estado = 1 WHERE id = $id");
                                                $qry_cont = mysql_query("SELECT * FROM bots WHERE id = '{$bot['id']}'");
                                                while ($bot_cont = mysql_fetch_assoc($qry_cont)) {
                                                    $contador = $bot_cont['siguiendo'];
                                                }
                                                $contador++;
                                                mysql_query("UPDATE bots SET siguiendo = '$contador' WHERE id = '{$bot['id']}'");
                                                $cantidad_seguidos++;
                                                $encontrados[] = $usuarios;
                                            }

                                        } else {
                                            mysql_query("UPDATE tweets SET estado = 2 WHERE id = $id");
                                        }
                                    } catch (Exception $e) {
                                        if ($e->getMessage() == 'You do not have permission to retrieve following status for both specified users.') {
                                            mysql_query("UPDATE tweets SET estado = 2 WHERE id = $id");
                                        } else if ($e->getMessage() == 'Rate limit exceeded. Clients may not make more than 350 requests per hour.') {
                                            mysql_query("DELETE FROM tweets WHERE id = $id;");
                                            if ($ambiente != 0) {
                                                $log .= "\n ERROR: " . $e . "\n\n";
                                            }
                                            $seguir = false;
                                            $recorrido = false;
                                            break;
                                        }else {
                                            if ($ambiente != 0) {
                                                $log .= "\n ERROR: " . $e . "\n\n";
                                            }
                                            $seguir = false;
                                            $recorrido = false;
                                            break;
                                        }
                                    }
                                }
                            }
                        } catch (Exception $e) {
                            if ($ambiente != 0) {
                                $log .= "\n ERROR: " . $e . "\n\n";
                            }
                            $seguir = false;
                            $recorrido = false;
                            break;
                        }
                    }
                } else {
                    if ($ambiente != 0) {
                        $log .= "Resultado Vacio\n";
                    }
                    $seguir = false;
                    break;
                }

                if ($ambiente != 0) {
                    $log .= "\n";
                }

                $pagina++;

                if ($pagina == 11) {
                    $seguir = false;
                }

            } catch (Exception $e) {
                if ($ambiente != 0) {
                    $log .= "\n ERROR: " . $e . "\n\n";
                }
                $seguir = false;
                $recorrido = false;
                break;
            }
        }

        $palabra_indice++;
    }

    if ($ambiente != 0) {
        echo "Cantidad Seguidos: " . $cantidad_seguidos . "\n";
    }
    //mysql_query("UPDATE bots SET siguiendo = $cantidad_seguidos WHERE id = '{$bot['id']}';");
}

if ($ambiente != 0) {
    if ($log != '') {
        echo "-----------------------------------------------\n";
        echo $log;
    }
}

?> 
