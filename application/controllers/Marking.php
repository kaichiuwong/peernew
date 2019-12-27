<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Marking extends MY_PasController {
    function __construct()
    {
        parent::__construct();
        $this->load->model('Assignment_mark_model');
    } 

    function group($unit_code = null)
    {
        if ($this->check_permission(20) ) {
            $this->load->model('Assignment_model');
            if ($unit_code) {
                $data['assignments'] = $this->Assignment_model->get_all_assignments_by_unit($unit_code);
                $data['unit'] = strtoupper($unit_code);
            }
            else {
                $data['assignments'] = $this->Assignment_model->get_all_assignments();
                $data['unit'] = null;
            }
            $data['_view'] = 'pages/assignment_marking/group';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
        }
    } 

    function individual()
    {
        if ($this->check_permission(20) ) {

        }
    }

}
