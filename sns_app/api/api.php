<?php

class Api {
    
    //LOCALHOST
    
    public $url = 'http://localhost:3000/api';

    public $curl;
    public $response;
    public $responseLength;
    public $responseCode;
    public $responseHeaders;

    /* ========================||========================||======================== */
    // CONSTRUCTOR
    /* ========================||========================||======================== */

    // Abrir a Conexão
    public function InitCurl(){
        $this->CreateHeaders();
        $this->curl = curl_init();
    }

    // Criar Headers
    public function CreateHeaders(){
        $this->responseHeaders = array(
            'Content-Type: application/json'
        );
    }

    // Fechar a Conexão
    public function CloseCurl(){
        curl_close($this->curl);
    }

    /* ========================||========================||======================== */
    // METHODS - FETCH
    /* ========================||========================||======================== */

    // Fetch
    public function fetch($path, $data = null, $id = null){

        $this->InitCurl();
        $data = $data !== null ? '/'.http_build_query($data) : '';
        $path = $id !==null ? $path . '/' . $id : $path;

        curl_setopt_array($this->curl, array(
			CURLOPT_URL => $this->url . '/'.$path. $data,
			CURLOPT_RETURNTRANSFER => true,
			CURLOPT_ENCODING => '',
			CURLOPT_MAXREDIRS => 10,
			CURLOPT_TIMEOUT => 0,
			CURLOPT_FOLLOWLOCATION => true,
			CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
			CURLOPT_CUSTOMREQUEST => 'GET',
			CURLOPT_HTTPHEADER => $this->responseHeaders,
		));

        $this->response = json_decode(curl_exec($this->curl), true);
        $this->responseCode = curl_getinfo($this->curl, CURLINFO_HTTP_CODE);
        $this->responseLength = $this->responseCode == 200 ? count($this->response) : 0;

        $this->CloseCurl();

        return array(
            'status' => $this->responseCode == 200 ? true : false,
            'response' => $this->response,
            'responseCode' => $this->responseCode,
            'responseLength' => $this->responseLength,
        );
    }

    // Fetch Products
    public function fetchProducts(){
        $path = 'products';
        $products = $this->fetch($path);
        return $products;
    }

    /* ========================||========================||======================== */
    // METHODS - POST
    /* ========================||========================||======================== */

    // Post
    public function post($path, $data, $id = null){

        $this->InitCurl();

        if($id !== null){
            $path = $path . '/' . $id;
        }

        curl_setopt_array($this->curl, array(
            CURLOPT_URL => $this->url . '/' .$path,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => '',
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => 'POST',
            CURLOPT_POSTFIELDS => json_encode($data),
            CURLOPT_HTTPHEADER => $this->responseHeaders,
        ));

        $this->response = json_decode(curl_exec($this->curl), true);
        $this->responseCode = curl_getinfo($this->curl, CURLINFO_HTTP_CODE);
        $this->responseLength = $this->responseCode == 200 ? count($this->response) : 0;

        $this->CloseCurl();

        return array(
            'status' => $this->responseCode == 200 ? true : false,
            'response' => $this->response,
            'responseCode' => $this->responseCode,
            'responseLength' => $this->responseLength,
        );

    }


    // Post New Product Family (Família de Produtos)
    public function postAddProductFamily($name, $code){
        $path = 'product_1st_categories';
        $data = array(
            'Name' => $name,
            'Code' => $code
        );
        $productFamily = $this->post($path, $data);
        return $productFamily;
    }

    /* ========================||========================||======================== */
    // METHODS - PUT
    /* ========================||========================||======================== */

    // Put
    public function put($id, $path, $data){

        $this->InitCurl();

        curl_setopt_array($this->curl, array(
            CURLOPT_URL => $this->url . '/' .$path . '/' . $id,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => '',
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => 'PUT',
            CURLOPT_POSTFIELDS => json_encode($data),
            CURLOPT_HTTPHEADER => $this->responseHeaders,
        ));

        $this->response = json_decode(curl_exec($this->curl), true);
        $this->responseCode = curl_getinfo($this->curl, CURLINFO_HTTP_CODE);
        $this->responseLength = $this->responseCode == 200 ? count($this->response) : 0;

        $this->CloseCurl();

        return array(
            'status' => $this->responseCode == 200 ? true : false,
            'response' => $this->response,
            'responseCode' => $this->responseCode,
            'responseLength' => $this->responseLength,
        );

    }

    /* ========================||========================||======================== */
    // METHODS - DELETE
    /* ========================||========================||======================== */

    // Delete
    public function delete($id, $path){

        $this->InitCurl();

        curl_setopt_array($this->curl, array(
            CURLOPT_URL => $this->url . '/' .$path . '/' . $id,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => '',
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_CUSTOMREQUEST => 'DELETE',
            CURLOPT_HTTPHEADER => $this->responseHeaders,
        ));

        $this->response = json_decode(curl_exec($this->curl), true);
        $this->responseCode = curl_getinfo($this->curl, CURLINFO_HTTP_CODE);
        $this->responseLength = $this->responseCode == 200 ? count($this->response) : 0;

        $this->CloseCurl();

        return array(
            'status' => $this->responseCode == 200 ? true : false,
            'response' => $this->response,
            'responseCode' => $this->responseCode,
            'responseLength' => $this->responseLength,
        );

    }

    




}