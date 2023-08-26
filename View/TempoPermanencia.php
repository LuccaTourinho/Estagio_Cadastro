<?php
class ViewTP{

    private $conn;

    public function __construct($conn) {
        $this->conn = $conn;
    }

    public function verTodos() {
        $sql = "SELECT * FROM View_Usuarios_Entradas_Saidas";
        $params = array();
        $result = pg_query_params($this->conn, $sql, $params);
        $rows = pg_fetch_all($result);
        return $rows;
    }
}?>