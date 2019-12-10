<?php
$connect = mysqli_connect("localhost", "jiang", "Bjmt@1234", "smarthome");

mysqli_set_charset($connect, 'utf8');
if ($connect) {
// echo "connection successful!";
} else {
echo "connection faild";
exit();
}