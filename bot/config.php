<?php

// Configuración Base de Datos
$con = mysql_connect('localhost', 'root', 'palacios123987');
mysql_select_db('projects_twbot', $con);
mysql_set_charset('utf8', $con);

// Configuración Bot
$key = 'LHfqxDyR3X095UCMW3gJjA';
$secret = 'bd8IPh4TLN8DXE7ic0p1IpeTjvPeO6OxCDNu7MnKFg';

// Timezone
//date_default_timezone_set('Etc/GMT-4');