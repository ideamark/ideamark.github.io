#!/bin/bash
# This shell script used to drop all the mysql tables in one database

$hostname='';
$userid='';
$password=' ';
$dbname='';
$connect=mysql_connect($hostname,$userid,$password);
mysql_select_db($dbname);
$result=mysql_query("show table status from $dbname",$connect);
while($data=mysql_fetch_array($result)) {
	mysql_query("drop table $data[Name]");
}

