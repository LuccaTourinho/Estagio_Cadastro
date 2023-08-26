<?php

class RepositoryEntrada
{
    private $conn;

    public function __construct($conn)
    {
        $this->conn = $conn;
    }

    public function inserirEntrada(ModelEntrada $entrada) {
        $sql = "SELECT insertEntrada($1, $2)";

        $param = array(
            $entrada->getIDCadastro(),
            $entrada->getEntrada()
        );

        $result = pg_query_params($this->conn, $sql, $param);

        if ($result) {
            $row = pg_fetch_row($result);
            var_dump($row);
            return true;
        } else {
            return false;
        }
    }

    public function inserirSaida(ModelEntrada $saida) {
        $sql = "SELECT insertSaida($1, $2, $3)";

        $param = array(
            $saida->getIDCadastro(),
            $saida->getEntrada(),
            $saida->getSaida()
        );

        $result = pg_query_params($this->conn, $sql, $param);

        if ($result) {
            $row = pg_fetch_row($result);
            var_dump($row);
            return true;
        } else {
            return false;
        }
    }

    public function lerEntradaAtual($ID_cadastro) {
        $sql = "SELECT * FROM readEntradaAtual($1)";

        $param = array($ID_cadastro);

        $result = pg_query_params($this->conn, $sql, $param);

        if ($result) {
            $row = pg_fetch_row($result);
            $rows = pg_fetch_all($result);
            return $rows;
        } else {
            return false;
        }
    }

    public function lerHistorico($ID_cadastro) {
        $sql = "SELECT * FROM readHistorico($1)";

        $param = array($ID_cadastro);

        $result = pg_query_params($this->conn, $sql, $param);

        if ($result) {
            $historico = array();
            $row = pg_fetch_all($result);
            return $row;
        } else {
            return false;
        }
    }

    public function cancelarEntrada($ID_cadastro) {
        $sql = "SELECT cancelarEntrada($1)";

        $param = array($ID_cadastro);

        $result = pg_query_params($this->conn, $sql, $param);

        if ($result) {
            $row = pg_fetch_row($result);
            return $row[0];
        } else {
            return false;
        }
    }


}
?>