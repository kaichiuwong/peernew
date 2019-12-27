<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Marking extends MY_PasController {
    function __construct()
    {
        parent::__construct();
        $this->load->model('Assignment_mark_model');
    } 


    function group()
    {
        if ($this->check_permission(20) ) {

        }
    } 

    function individual()
    {
        if ($this->check_permission(20) ) {

        }
    }

}
