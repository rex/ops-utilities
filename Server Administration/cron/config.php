<?php 

/**
 * Config.php, where you will define all settings.
 */

## First, let's set up all our fun details.

// Define all database settings.
define('DB_USER','root');
define('DB_PASS','0pxLkukl0Nomaahkmo6O');
define('DB_NAME','cron');
define('DB_HOST','localhost');

// Now we define a few things for our error logging functions
define('ERROR_LOG_LOCATION','error_log.log');	// Change if you want, this just allows the log to keep from getting cluttered up with random crap.
define('CURRENT_DATE_FORMAT','Y-m-d H:i:s');	// Defaults to MySQL timestamp: 2010-09-14 17:27:09

// Grab the classes for error handling and database administration...
//require_once('includes/class.error.php');	// Get our error-handling functions.
//require_once('includes/class.db.php');	// Get our database goodies.

// Load PEAR's mail classes
//require_once 'Mail.php';
//require_once 'Mail/mime.php'; 

// Fully loaded, and away we go...


/**
 * End of file 'config.php'
 */
?>