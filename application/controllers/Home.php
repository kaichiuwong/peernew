<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Home extends MY_PasController {
    
	public function index()
	{
        if ($this->check_permission(20, false)) {
            redirect('Assignmentadmin');
        }
        if ($this->check_permission(10)) {
            /*
            $this->load_header();
            $this->load->view('pages/home/'.$this->user_role.'-index');      
            $this->load_footer();
            */
            redirect('Assignment');
        }
	}
}
