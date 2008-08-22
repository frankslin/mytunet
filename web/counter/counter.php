<?PHP
/***************************************************
	Name of file containing the count total.
***************************************************/
$file = "counter/counter.txt";

$open = fopen($file, "r");
$size = filesize($file);
$count = fread($open, $size);
fclose($open);

/***************************************************
	If cookie 'simplecount' is not set it will
	add 1 to the counter and set the cookie.
	
	If the cookie does exist, this section will
	be skipped.
***************************************************/
if (!isset($_COOKIE['simplecount'])) {

	$open = fopen($file, "w");
	$count++;
	fwrite($open, $count);
	fclose($open);

	setcookie("simplecount","Counted!",time()+66600000);

}
?>