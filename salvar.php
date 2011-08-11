<?php
if(isset($GLOBALS["HTTP_RAW_POST_DATA"]))
	{
		$jpg = $GLOBALS["HTTP_RAW_POST_DATA"];
		$img = $_GET["img"];
		$filename = "images/teste_". mktime(). ".jpg";
		file_put_contents($filename, $jpg);
	} 
else
	{
		echo "imagem não recebida.";
	}
?>