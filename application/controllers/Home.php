<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Home extends MY_PasController {
    
	public function index()
	{
        if ($this->check_permission(90, false)) {
            redirect('Useradministration');
        }
        if ($this->check_permission(50, false)) {
            redirect('Unit');
        }
        if ($this->check_permission(30, false)) {
            redirect('Assignmentadmin');
        }
        if ($this->check_permission(20, false)) {
            redirect('Marking');
        }
        if ($this->check_permission(10)) {
            redirect('Assignment');
        }
	}
}
