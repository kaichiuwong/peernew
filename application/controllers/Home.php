<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Home extends MY_PasController {
    
	public function index()
	{
        if ($this->check_permission(30, false)) {
            redirect('Assignmentadmin');
        }
        if ($this->check_permission(10)) {
            redirect('Assignment');
        }
	}
}
