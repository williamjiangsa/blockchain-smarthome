<?php
include 'conn.php';

$display = 3; //每页显示10个数据
$start = 0;
$queryResult = $connect->query("SELECT blockid, blocktime FROM block Order By blockid Desc LIMIT $start,$display");
$result = array();
while ( $fetchData = $queryResult -> fetch_assoc()){
    $result [] = $fetchData;
}
echo json_encode($result,JSON_UNESCAPED_UNICODE);
mysqli_close($connect);
?>
