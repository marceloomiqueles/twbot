#!/usr/bin/php  
<?php 

require('config.php');
require('ambiente.php');
require_once 'Exception.php';
require_once 'Twitter.php';
use \TijsVerkoyen\Twitter\Twitter;


if ($ambiente != 0) {
    $log = "------------------------------------------------------------------------\n";
    $log .= "Inicio Log - ";
    $log .= date("D, d/m/Y, H:i:s")."\n";
}

$twitter = new Twitter($key, $secret);

$bots = mysql_query("SELECT * FROM bots WHERE estado = 1");

while ($bot = mysql_fetch_assoc($bots)) {
    $twitter->setOAuthToken($bot['tw_token']);
    $twitter->setOAuthTokenSecret($bot['tw_secret']);

    $ciudad_indice = $bot['ciudad_indice'];
    $palabra_indice = $bot['palabra_indice'];
    $cantidad_seguidos = $bot['siguiendo'];
    $max_seguir = $bot['cantidad_seguir'];
    $cantidad_seguir = 0;

    $palabras = mysql_query("SELECT * FROM palabras WHERE bot_id = '{$bot['id']}';");

    $arrayPalabras = array();
    $index = 1;
    while ($palabra = mysql_fetch_assoc($palabras)) {
        $arrayPalabras[$index] = $palabra['palabra'];
        $index ++;
    }
    $cantidad_palabras = count($arrayPalabras);
    mysql_query("UPDATE bots SET palabra_maximo = $cantidad_palabras WHERE id = '{$bot['id']}';");
    if ($ambiente != 0) {
        $log .= "---------------------------\nPalabras\n";
        $log .= "Query: SELECT * FROM palabras WHERE bot_id = '" . $bot['id'] . "';\n";
        $log .= print_r($arrayPalabras, true);
        $log .= "\n";
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
    if ($ambiente != 0) {
        $log .= "---------------------------\Ciudades:\n";
        $log .= print_r($arrayCiudades, true);
        $log .= "\n";
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
        $log .= "--------------------\nGeo Punto: ";
        $log .= $geo . "\n";
    }

    $encontrados = array();
    $seguir = true;
    $recorrido = true;

    while ($recorrido == true) {
        if ($palabra_indice > $cantidad_palabras) {
            $palabra_indice = 1;
            $recorrido = false;
        }

        $query_tw_palabra = $arrayPalabras[$palabra_indice];
        
        $pagina = 1;
        $seguir = true;
        $maxId = null;

        while ($seguir == true) {
            try {

                if ($ambiente != 0) {
                    $log .= "-----------------\nPagina: " . $pagina . "\n";
                }

                $buscados = $twitter->searchTweets($query_tw_palabra, $geo, null, null, null, 5, null, null, $maxId, null);

                print_r($buscados);

                break;

                if ($ambiente != 0) {
                    $log .= "Palabra Indice: " . $palabra_indice . "\n";
                    $log .=  "Query TW: " . $query_tw_palabra . "\n";
                }

                if (!empty($buscados['statuses'])) {
                    foreach ($buscados['statuses'] as $usuarios) {

                        $maxId = $usuarios['user']['id'];

                        try {
                            $qry = mysql_query("SELECT * FROM tweets WHERE bot_id = '{$bot['id']}' AND tw_usuario_id = '{$usuarios['user']['id']}'");

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

                                if ($coincidencia) {
                                    if (!isset($usuarios['user']['location'])) {
                                        $usuarios['location'] = "";
                                    }

                                    $query_insert = "INSERT INTO tweets (bot_id, tw_usuario_id, estado, tw_tweet_id, tw_location, tw_text, tw_created_at, tw_usuario, created_at, updated_at, palabra, ciudad) VALUES ('" . $bot['id'] . "', '" . $usuarios['user']['id'] . "', '0', '" . $usuarios['id'] . "', '" . $usuarios['user']['location'] . "', '" . $usuarios['text'] . "', '" . $usuarios['created_at'] . "', '" . $usuarios['user']['screen_name'] . "', '" .  date("Y-m-d H:i:s") . "', '" . date("Y-m-d H:i:s") . "', '". $query_tw_palabra ."', '". $arrayCiudades[$ciudad_indice]['nombre'] ."');";
                                    if ($ambiente != 0) {
                                        $log .= "--------------------\nQuery Insert: " . $query_insert . "\n";
                                    }

                                    mysql_query($query_insert);
                                    $id = mysql_insert_id();

                                    try {
                                        $siguiendo = $twitter->friendshipsLookup(array($usuarios['user']['id']), null);

                                        if ($ambiente != 0) {
                                            $log .= "////////////// siguiendo:\n";
                                            $log .= print_r($siguiendo, true);
                                        }

                                        if (!in_array('followed_by', $siguiendo[0]['connections'])) {
                                            if (!in_array('following', $siguiendo[0]['connections']) && !in_array('following_requested', $siguiendo[0]['connections'])) {
                                                $crea_amistad = $twitter->friendshipsCreate($usuarios['user']['id'], null, false);

                                                if ($ambiente != 0) {
                                                    $log .= "////////////// resultado crea_amistad:\n";
                                                    $log .= print_r($crea_amistad, true);
                                                }

                                                mysql_query("UPDATE tweets SET estado = 1 WHERE id = $id");
                                                $qry_cont = mysql_query("SELECT * FROM bots WHERE id = '{$bot['id']}'");
                                                while ($bot_cont = mysql_fetch_assoc($qry_cont)) {
                                                    $contador = $bot_cont['siguiendo'];
                                                }
                                                $contador++;
                                                mysql_query("UPDATE bots SET siguiendo = '$contador' WHERE id = '{$bot['id']}'");
                                                $cantidad_seguidos++;
                                                $encontrados[] = $usuarios;

                                                $cantidad_seguir++;
                                                if ($ambiente != 0) {
                                                    $log .= "---------------------------------\n";
                                                    $log .= "Cantidad a seguir: " . $cantidad_seguir . "\n";
                                                    $log .= "Maximo a seguir: " . $max_seguir . "\n";
                                                    $log .= "---------------------------------\n";
                                                }
                                                if ($cantidad_seguir >= $max_seguir) {
                                                    $seguir = false;
                                                    $recorrido = false;
                                                    if ($ambiente != 0) {
                                                        $log .= "FINALIZA POR MAXIMO\n---------------------------------\n";
                                                    }
                                                    break;
                                                }
                                            }
                                        } else {
                                            mysql_query("UPDATE tweets SET estado = 2 WHERE id = $id");
                                            if ($ambiente != 0) {
                                                $log .= "---------------------------------\nYa está siguiendo la cuenta\n";
                                                $log .= "---------------------------------\n";
                                                $log .= "Cantidad a seguir: " . $cantidad_seguir . "\n";
                                                $log .= "Maximo a seguir: " . $max_seguir . "\n";
                                                $log .= "---------------------------------\n";
                                            }
                                        }

                                    } catch (Exception $e) {
                                        if ($e->getMessage() == 'You do not have permission to retrieve following status for both specified users.') {
                                            mysql_query("UPDATE tweets SET estado = 3 WHERE id = $id");
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

                    if (empty($buscados['search_metadata']['next_results'])) {
                        $seguir = false;
                        if ($ambiente != 0) {
                            $log .= "\n ////// SE ALCANZÓ LA PÁGINA FINAL DE LA BUSQUEDA ///// \n\n";
                        }
                    } else {
                        $pagina++;
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
        $log .= "-------------------\nCantidad Seguidos: " . $cantidad_seguidos . "\n";
    }
    //mysql_query("UPDATE bots SET siguiendo = $cantidad_seguidos WHERE id = '{$bot['id']}';");
    mysql_query("UPDATE bots SET palabra_indice = $palabra_indice WHERE id = '{$bot['id']}';");

}

if ($ambiente != 0) {
    if ($log != '') {
        $log .= "-----------------------------------------------\n";
        $log .= "\n\nEncontrados:\n" . print_r($encontrados, true);

        $log .= "\n\nFin del proceso: ";
        $log .= date("D, d/m/Y, H:i:s")."\n";

        $log = $log."\nGuardando log...\n\n\n------------------------------------------------------------------------------------------------\n------------------------------------------------------------------------------------------------\n\n\n";

        //exec("rm " . $directorio . "logfollow.txt");

        $fp=fopen($directorio . "logfollow.txt","a");

        fwrite($fp,$log);
        fclose($fp) ;

    }
}


//*******************//
