<?php

class ModelEndereco{
    private $ID_endereco;
    private $UF;
    private $municipio;
    private $CEP;
    private $complemento;

    public function __construct($ID_endereco, $UF, $municipio, $CEP, $complemento)
    {
        if($ID_endereco !== null){
            $this->ID_endereco = $ID_endereco;
        }
        $this->UF = $UF;
        $this->municipio = $municipio;
        $this->CEP = $CEP;
        $this->complemento = $complemento;
    }

    public function getIDEndereco()
    {
        return $this->ID_endereco;
    }

    public function getUF()
    {
        return $this->UF;
    }

    public function getMunicipio()
    {
        return $this->municipio;
    }

    public function getCEP()
    {
        return $this->CEP;
    }

    public function getComplemento()
    {
        return $this->complemento;
    }

    public function setIDEndereco($ID_endereco)
    {
        $this->ID_endereco = $ID_endereco;
    }

    public function setUF($UF)
    {
        $this->UF = $UF;
    }

    public function setMunicipio($municipio)
    {
        $this->municipio = $municipio;
    }

    public function setCEP($CEP)
    {
        $this->CEP = $CEP;
    }

    public function setComplemento($complemento)
    {
        $this->complemento = $complemento;
    }

}
?>