<?php

class ModelCadastro{
    private $ID_cadastro;
    private $ID_endereco;
    private $nome;
    private $data_nascimento;
    private $RG;
    private $CPF;
    private $telefone_primario;
    private $telefone_secundario;
    private $email_principal;
    private $email_alternativo;
    private $estado_civil;
    private $usuario;
    private $senha;

    public function __construct($ID_cadastro, $ID_endereco, $nome, $data_nascimento, $RG, $CPF, $telefone_primario, $telefone_secundario, $email_principal, $email_alternativo, $estado_civil, $usuario, $senha)
    {
        if($ID_cadastro !== null){
            $this->ID_cadastro = $ID_cadastro;
        }
        $this->ID_endereco = $ID_endereco;
        $this->nome = $nome;
        $this->data_nascimento = $data_nascimento;
        $this->RG = $RG;
        $this->CPF = $CPF;
        $this->telefone_primario = $telefone_primario;
        $this->telefone_secundario = $telefone_secundario;
        $this->email_principal = $email_principal;
        $this->email_alternativo = $email_alternativo;
        $this->estado_civil = $estado_civil;
        $this->usuario = $usuario;
        $this->senha = $senha;
    }


    public function getIDCadastro()
    {
        return $this->ID_cadastro;
    }


    public function setIDCadastro($ID_cadastro)
    {
        $this->ID_cadastro = $ID_cadastro;
    }


    public function getIDEndereco()
    {
        return $this->ID_endereco;
    }


    public function setIDEndereco($ID_endereco)
    {
        $this->ID_endereco = $ID_endereco;
    }


    public function getNome()
    {
        return $this->nome;
    }


    public function setNome($nome)
    {
        $this->nome = $nome;
    }


    public function getDataNascimento()
    {
        return $this->data_nascimento;
    }


    public function setDataNascimento($data_nascimento)
    {
        $this->data_nascimento = $data_nascimento;
    }


    public function getRG()
    {
        return $this->RG;
    }


    public function setRG($RG)
    {
        $this->RG = $RG;
    }


    public function getCPF()
    {
        return $this->CPF;
    }


    public function setCPF($CPF)
    {
        $this->CPF = $CPF;
    }


    public function getTelefonePrimario()
    {
        return $this->telefone_primario;
    }


    public function setTelefonePrimario($telefone_primario)
    {
        $this->telefone_primario = $telefone_primario;
    }


    public function getTelefoneSecundario()
    {
        return $this->telefone_secundario;
    }


    public function setTelefoneSecundario($telefone_secundario)
    {
        $this->telefone_secundario = $telefone_secundario;
    }


    public function getEmailPrincipal()
    {
        return $this->email_principal;
    }


    public function setEmailPrincipal($email_principal)
    {
        $this->email_principal = $email_principal;
    }


    public function getEmailAlternativo()
    {
        return $this->email_alternativo;
    }


    public function setEmailAlternativo($email_alternativo)
    {
        $this->email_alternativo = $email_alternativo;
    }


    public function getEstadoCivil()
    {
        return $this->estado_civil;
    }


    public function setEstadoCivil($estado_civil)
    {
        $this->estado_civil = $estado_civil;
    }


    public function getUsuario()
    {
        return $this->usuario;
    }


    public function setUsuario($usuario)
    {
        $this->usuario = $usuario;
    }


    public function getSenha()
    {
        return $this->senha;
    }


    public function setSenha($senha)
    {
        $this->senha = $senha;
    }

}

?>