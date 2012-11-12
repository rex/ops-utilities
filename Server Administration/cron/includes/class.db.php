<?php 

/**
 * Class.db.php, where you talk to the database and CRUD and all that fun stuff.
 * 
 * ## LOCATION:
 * /db_populate/includes/class.db.php
 * 
 * @package Gazelle Enhanced
 * @author Pierce
 * @copyright View included license.txt, located in the root directory. 
 * @link http://github.com/piercemoore/GazelleEnhanced/
 * @link http://gazelle.refreshedweb.com
 */

class DB {
	
	public function __construct()
	{
		$this->error = new Error;
		$this->user = DB_USER;
		$this->pass = DB_PASS;
		$this->host = DB_HOST;
		$this->target_db = DB_NAME;
		try {
			if(!$this->_connect(true)) {
				throw new Exception("Connection to '$this->host' failed. Error: " . self::getError());
			}
			if(!$this->_select($this->target_db)) {
				throw new Exception("Connection to database '$this->target_db' failed. Error: " . self::getError());
			}
		} catch (Exception $e) {
			error::fullHalt($e->getMessage(),__FUNCTION__,__LINE__);
		}
		
	}

	final private function _connect()
	{
		if(mysql_connect($this->host,$this->user,$this->pass)) {
			return true;
		}
		return false;
	}
	
	final private function _select($db)
	{
		if(mysql_select_db($db)) {
			return true;
		}
		return false;
	} 
	
	final public function prepare($var)
	{
		if(is_array($var)) {
			foreach($var as $k=>$v) {
				$ret[$k] = mysql_real_escape_string($v);
			}
		} else {
			$ret = mysql_real_escape_string($var);
		}
		return $ret;
	}
	
	public function query($sql,$debug=0,$unsafe=0)
	{
		if($unsafe == 0) {
			$sql = self::prepare($sql);
		}	
		if($debug == 1) {
			print "$sql <br />";
		}
		$data = array();
		if($q = mysql_query($sql)) {
			$ins_id = @self::getInsertId();
			if(!empty($ins_id) || ($ins_id != '')) {
				return $ins_id;
			} else {
				$rows = @self::numRows($q);
				if($rows == 1) {
					return @mysql_fetch_assoc($q);
				} else {
					while($row = @mysql_fetch_assoc($q)) {
						$data[] = $row;
					}
				}
				return $data;
			}
		}
		return false;
	}
	
	public function getInsertId()
	{
		return mysql_insert_id();
	}
	
	public function getError()
	{
		return mysql_error();
	}
	
	public function numRows($id)
	{
		return mysql_num_rows($id);
	}

	public function countFieldsInTable($name)
	{
		$q = self::query("SELECT * FROM `$name`");
		return count($q);
	}

}


/**
 * End of file 'class.db.php'
 */
?>