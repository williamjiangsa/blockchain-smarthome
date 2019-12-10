<?php
include 'conn.php';
$ts4 = $_GET['TS4'];
$ts5 = $_GET['TS5'];


$display = 1; //每页显示10个数据
$start = 0;
$queryResult = $connect->query("SELECT tsid FROM transactions Order By tsid Desc LIMIT $start,$display");
$result = array();
while ( $fetchData = $queryResult -> fetch_assoc()){
    $result [] = $fetchData;
}
$curid = intval($result[0]['tsid']);
$sql = "UPDATE transactions SET ts4 = $ts4, ts5 = $ts5 WHERE tsid = $curid";
if ($connect->query($sql) === TRUE) {
$response['result'] = "success";
$response['id'] = $curid;
     echo json_encode($response);
     }else {
       echo "Error:".$sql."<br/>".$connect->error;
     }
mysqli_close($connect);
?>
