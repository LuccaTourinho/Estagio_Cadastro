<?php

class RepositoryEndereco
{
    private $conn;

    public function __construct($conn)
    {
        $this->conn = $conn;
    }

    public function salvarEndereco(ModelEndereco $endereco){
        $sql = "SELECT insertEndereco($1, $2, $3, $4)";

        $param = array(
          $endereco->getUF(),
          $endereco->getMunicipio(),
          $endereco->getCEP(),
          $endereco->getComplemento()
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

    public function atualizarEndereco(ModelEndereco $endereco)
    {
        $sql = "SELECT updateEndereco($1, $2, $3, $4, $5)";

        $param = array(
            $endereco->getIDEndereco(), // ID_endereco
            $endereco->getUF(),
            $endereco->getMunicipio(),
            $endereco->getCEP(),
            $endereco->getComplemento()
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

    public function lerEndereco($ID_endereco)
    {
        $sql = "SELECT * FROM readEndereco($1)";

        $param = array($ID_endereco);

        $result = pg_query_params($this->conn, $sql, $param);

        if ($result) {
            $row = pg_fetch_assoc($result);
            return $row;
        } else {
            return null;
        }
    }

    public function excluirEndereco($ID_endereco)
    {
        $sql = "SELECT deleteEndereco($1)";

        $param = array($ID_endereco);

        $result = pg_query_params($this->conn, $sql, $param);

        if ($result) {
            $row = pg_fetch_row($result);
            return $row[0];
        } else {
            return "Erro ao executar a exclusão.";
        }
    }

}

?>