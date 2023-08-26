<?php
    require 'Endereco\ModelEndereco.php';
    require 'Endereco\RepositoryEndereco.php';
    require 'Cadastro\ModelCadastro.php';
    require 'Cadastro\RepositoryCadastro.php';
    require 'Entrada_Saida\ModelEntrada.php';
    require 'Entrada_Saida\RepositoryEntrada.php';
    require 'View\TempoPermanencia.php';


    //Conectando ao banco

    $conn = pg_connect("host=localhost port=5432 dbname=Estagio user=postgres password=041199");

    //Instanciando os repositorios

    $enderecoRepository = new RepositoryEndereco($conn);
    $cadastroRepository = new RepositoryCadastro($conn);
    $entradaSaidaRepository = new RepositoryEntrada($conn);
    $viewRepository = new ViewTP($conn);


    // Instanciando o endereco

    $endereco = new ModelEndereco(
        2,
        'SP',
        'São Paulo',
        '49870-195',
        'Ed. Mar ap.207');

    // Instanciando o cadastro

    // Variavel para utilizar no switch

    $teste = 0;

    /*

    1 - Inserir Endereco
    2 - Atualizar Endereco
    3 - Ler Endereco
    4 - Deletar Endereco

    5 - Inserir Cadastro
    6 - Atualizar Cadastro
    7 - Ler Cadastro
    8 - Deletar Cadastro

    9  - Inserir Entrada
    10 - Inserir Saida
    11 - Ler Entrada
    12 - Ver Historico
    13 - Cancelar Entrada

     */

    switch($teste){
        case 1:
            $enderecoRepository->salvarEndereco($endereco);
            break;
        case 2:
            $endereco->setIDEndereco(1);
            $enderecoRepository->atualizarEndereco($endereco);
            break;
        case 3:
            $enderecoTabela = $enderecoRepository->lerEndereco($endereco->getIDEndereco());
            if ($enderecoTabela){
                print_r($enderecoTabela);
            }
            break;
        case 4:
            $resultadoExclusao = $enderecoRepository->excluirEndereco($endereco->getIDEndereco());
            echo $resultadoExclusao;
            break;

        default:
            break;
    };


    // Instanciando o cadastro

    $cadastro = new ModelCadastro(
        null,
        1,
        'Laoao',
        '1990-06-07',
        '12.989.789-00',
        '223.876.789-00',
        '(987) 65229-2109',
        '(123) 35118-9001',
        'email@exe.com',
        'email_altvo@exemplo.com',
        'CASADO',
        'usopoio',
        'Seyh123@'
    );


    switch ($teste){
        case 5:
            $resultadoInsercao = $cadastroRepository->inserirCadastro($cadastro);
            break;
        case 6:
            $cadastro->setIDCadastro(1);
            $resultadoInsercao = $cadastroRepository->atualizarCadastro($cadastro);
            break;
        case 7:
            $cadastroTabela= $cadastroRepository->lerCadastroPorUsuarioSenha($cadastro->getUsuario(), $cadastro->getSenha());
            if ($cadastroTabela){
                print_r($cadastroTabela);
            }
            break;
        case 8:
            $resultadoExclusao = $cadastroRepository->excluirCadastroPorUsuarioSenha($cadastro->getUsuario(), $cadastro->getSenha());
            echo $resultadoExclusao;
            break;
        default:
            break;
    }

    // Instanciando a entrada

    $entrada = new ModelEntrada(
        null,
        1,
        '2023-08-25 10:00:00',
        null
    );

    switch ($teste) {
        case 9:
            $resultadoInsercao = $entradaSaidaRepository->inserirEntrada($entrada);
            echo $resultadoInsercao;
            break;
        case 10:
            $entrada->setSaida('2023-08-25 18:00:00');
            $resultadoSaida = $entradaSaidaRepository->inserirSaida($entrada);
            echo $resultadoSaida;
            break;
        case 11:
            $entradaTabela = $entradaSaidaRepository->lerEntradaAtual($entrada->getIDCadastro());
            if ($entradaTabela) {
                print_r($entradaTabela);
            }
            break;
        case 12:
            $historico = $entradaSaidaRepository->lerHistorico($entrada->getIDCadastro());
            if ($historico) {
                print_r($historico);
            }
            break;
        case 13:
            $resultadoCancelamento = $entradaSaidaRepository->cancelarEntrada($entrada->getIDCadastro());
            echo $resultadoCancelamento;
            break;
        default:
            break;
    }

    $testeView = true;

    if($testeView){
        $viewTabela = $viewRepository->verTodos();
        print_r($viewTabela);
    }


?>