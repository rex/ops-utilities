<?php 

/**
 * Class.error.php is where you handle all the crap that doesn't go to plan.
 * 
 * ## LOCATION:
 * /db_populate/includes/config.php
 * 
 * @package Gazelle Enhanced
 * @author Pierce
 * @copyright View included license.txt, located in the root directory. 
 * @link http://github.com/piercemoore/GazelleEnhanced/
 * @link http://gazelle.refreshedweb.com
 */


class Error {
	
	public function __construct()
	{
		$this->log_location = ERROR_LOG_LOCATION;
		$this->date_format = CURRENT_DATE_FORMAT;
	}
	
	public function log($message,$function=null,$line=null,$die=0)
	{
		$message = date($this->date_format);
		foreach(func_get_args() as $k=>$v) {
			if(!empty($v) || ($v != '')) {
				if($k != 3) {
					$message .= ' - ' . $v;
				}
			}
		}
		if(!error_log($message . "\r\n",3,$this->log_location)) {
			die("Log entry unable to be created. Please check all settings.");
		}
		if($die!=1) {
			trigger_error($message);
		} else if($die = 1) {
			die($message);
		}
	}
	
	public function fullHalt($message,$function=null,$line=null)
	{
		if(!error::log($message,$function,$line,1)) {
			die($message);
		}
	}
}


/**
 * End of file 'class.error.php'
 */
?>