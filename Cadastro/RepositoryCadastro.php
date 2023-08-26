<?php

class RepositoryCadastro {
    private $conn;

    public function __construct($conn) {
        $this->conn = $conn;
    }

    public function inserirCadastro(ModelCadastro $cadastro) {
        $sql = "SELECT insertCadastro($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)";

        $param = array(
            $cadastro->getIDEndereco(),
            $cadastro->getNome(),
            $cadastro->getDataNascimento(),
            $cadastro->getRG(),
            $cadastro->getCPF(),
            $cadastro->getTelefonePrimario(),
            $cadastro->getTelefoneSecundario(),
            $cadastro->getEmailPrincipal(),
            $cadastro->getEmailAlternativo(),
            $cadastro->getEstadoCivil(),
            $cadastro->getUsuario(),
            $cadastro->getSenha()
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

    public function atualizarCadastro(ModelCadastro $cadastro) {
        $sql = "SELECT updateCadastro($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)";

        $param = array(
            $cadastro->getIDCadastro(),
            $cadastro->getIDEndereco(),
            $cadastro->getNome(),
            $cadastro->getDataNascimento(),
            $cadastro->getRG(),
            $cadastro->getCPF(),
            $cadastro->getTelefonePrimario(),
            $cadastro->getTelefoneSecundario(),
            $cadastro->getEmailPrincipal(),
            $cadastro->getEmailAlternativo(),
            $cadastro->getEstadoCivil(),
            $cadastro->getUsuario(),
            $cadastro->getSenha()
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

    public function lerCadastroPorUsuarioSenha($usuario, $senha) {
        $sql = "SELECT * FROM readCadastro($1, $2)";

        $param = array($usuario, $senha);

        $result = pg_query_params($this->conn, $sql, $param);

        if ($result) {
            $rows = pg_fetch_all($result);
            return $rows;
        } else {
            return false;
        }
    }

    public function excluirCadastroPorUsuarioSenha($usuario, $senha) {
        $sql = "SELECT deleteCadastro($1, $2)";

        $param = array(
            $usuario,
            $senha
        );

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