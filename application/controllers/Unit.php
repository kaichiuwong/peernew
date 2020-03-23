<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Unit extends MY_PasController {
    function __construct()
    {
        parent::__construct();
        $this->load->model('Unit_model');
    } 
    
    function index()
    {
        if ($this->check_permission(50)) {
            #$data['assignments'] = $this->Unit_model->get_all_assignments_student($this->get_login_user(), $this->current_sem());
            $data['units'] = $this->Unit_model->get_all_units();
            $data['_view'] = 'pages/unit/index';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
        }
    }

    function info($asg_id = null)
    {
        $done = false;
        do 
        {
            if (!$this->check_permission(50) ) break;
            $asg_result = $this->assignment_check($asg_id);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['assignment'] = $asg_result['asg_info'];
            $data['asg_header'] = $asg_result['asg_header'];

            $data['asg_id'] = $asg_id;
            $data['all_units'] = $this->Unit_model->get_all_units();
            $data['Assignment_dates'] = $this->Assignment_date_model->get_all_dates_by_asg_id($decode_asg_id);
            $data['_view'] = 'pages/assignment/info';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Assignment");
    } 

}
