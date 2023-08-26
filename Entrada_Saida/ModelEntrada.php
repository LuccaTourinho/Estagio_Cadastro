<?php

class ModelEntrada{
    private $ID_ea;
    private $ID_cadastro;
    private $entrada;
    private $saida;


    public function __construct($ID_ea, $ID_cadastro, $entrada, $saida)
    {
        if($ID_ea !== null){
            $this->ID_ea = $ID_ea;
        }
        $this->ID_cadastro = $ID_cadastro;
        $this->entrada = $entrada;
        $this->saida = $saida;
    }

    public function getIDEa()
    {
        return $this->ID_ea;
    }

    public function setIDEa($ID_ea)
    {
        $this->ID_ea = $ID_ea;
    }

    public function getIDCadastro()
    {
        return $this->ID_cadastro;
    }

    public function setIDCadastro($ID_cadastro)
    {
        $this->ID_cadastro = $ID_cadastro;
    }

    public function getEntrada()
    {
        return $this->entrada;
    }

    public function setEntrada($entrada)
    {
        $this->entrada = $entrada;
    }

    public function getSaida()
    {
        return $this->saida;
    }

    public function setSaida($saida)
    {
        $this->saida = $saida;
    }


}


?>