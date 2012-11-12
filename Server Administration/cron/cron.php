
<?php

// #!/usr/bin/php -q

require_once('config.php');

// Declare vars for database. Nothing done yet.
define('CRON_RUN',false);
define('BACKUP_MYSQL',false);
define('BACKUP_WP',false);
define('BACKUP_SITES',false);
define('DAILY_DEAL',false);
define('CUR_DATE', date("Y-m-d-H-i-s"));
define('CURRENT_MYSQL_BACKUP_PATH','/sqlBackups/');
define('CURRENT_MYSQL_BACKUP_NAME', 'mysql_' . CUR_DATE . '.sql');
define('EXTENDED_MYSQL_BACKUP_NAME', 'mysql_' . CUR_DATE . '.sql');
define('CURRENT_WP_BACKUP_NAME', 'wp_' . CUR_DATE . '.sql');
define('CURRENT_SITE_BACKUP_NAME', 'site_' . CUR_DATE . '.tgz');
define('BACKUP_DBS','--all-databases');
define('EMAIL_REC','piercemoore@gmail.com');
define('EMAIL_SEND','backup@piercemoore.com');
define('EMAIL_FROM','Nightly Server Backup');
define('EMAIL_SUBJECT','Nightly Server Backup - ' . CUR_DATE);
define('FILE_TMP_DIR','files/');

class Cron {

	function __construct() 
	{
		$this->db = new Db();
		$this->error = new Error();
	}
	
	function init()
	{
		$this->backupMysql(); 
	}
	
	function backupMysql()
	{		
		$createBackup = "mysqldump -u " . DB_USER . " --password=" . DB_PASS . " " . BACKUP_DBS . " > " . CURRENT_MYSQL_BACKUP_PATH . CURRENT_MYSQL_BACKUP_NAME;
		$createZip = "tar cvzf " . EXTENDED_MYSQL_BACKUP_NAME . ' ' . CURRENT_MYSQL_BACKUP_NAME;
		exec($createBackup);
		exec($createZip);
		
		$headers = array('From' => EMAIL_FROM . '<' . EMAIL_SEND . '>', 'Subject' => EMAIL_SUBJECT);
		$textMessage = EXTENDED_MYSQL_BACKUP_NAME;
		$htmlMessage = "This is a nightly backup run.";
		
		$mime = new Mail_Mime("\n");
		$mime->setTxtBody($textMessage);
		$mime->setHtmlBody($htmlMessage);
		$mime->addAttachment(EXTENDED_MYSQL_BACKUP_NAME, 'text/plain');
		$body = $mime->get();
		$hdrs = $mime->headers($headers);
		$mail = &Mail::factory('mail');
		$mail->send(EMAIL_REC, $hdrs, $body);
		
		unlink(CURRENT_MYSQL_BACKUP_NAME);
		unlink(EXTENDED_MYSQL_BACKUP_NAME);
	}

}

//$cron = new Cron();
//$cron->init();

//mail('piercemoore@gmail.com','Cron working!','The cronjob you installed is working. Lucky you.');

$createBackup = "mysqldump -u " . DB_USER . " --password=" . DB_PASS . " " . BACKUP_DBS . " > " . CURRENT_MYSQL_BACKUP_PATH . CURRENT_MYSQL_BACKUP_NAME;
exec($createBackup);


?>
