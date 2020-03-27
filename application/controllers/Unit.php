<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Unit extends MY_PasController {
    function __construct()
    {
        parent::__construct();
        $this->load->model('Unit_model');
        $this->load->model('Semester_model');
        $this->load->model('Unit_staff_model');
    } 
    
    function index()
    {
        if ($this->check_permission(50)) {
            $data['units'] = $this->Unit_model->get_all_units_with_disabled();
            $data['_view'] = 'pages/unit/index';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
        }
    }

    function add()
    {
        $done = false;
        do 
        {
            if (!$this->check_permission(50) ) break;
            $data['error_msg'] = "";
            if (isset($_POST['submit'])) {
                if ($this->Unit_model->get_unit_id(strtoupper($this->input->post('unit_code')), $this->input->post('sem')) ) {
                    $data['error_msg'] = "Unit already exist in the system.";
                }
                else {
                    $data_param = array (
                        'unit_code' => strtoupper($this->input->post('unit_code')),
                        'sem' => $this->input->post('sem'),
                        'unit_description' => $this->input->post('unit_desc')
                    );
                    $unit_id = $this->Unit_model->add_unit($data_param);
                    if ($unit_id) {
                        $staff_param = array(
                            'unit_id' => $unit_id,
                            'username' => $this->input->post('unit_co')
                        );
                        $this->Unit_staff_model->add_unit_staff($this->get_login_user(), $staff_param);
                        redirect("Unit");
                    }
                }
            }
            $data['staff_list'] = array_merge($this->User->get_user_list_by_permission(50), $this->User->get_user_list_by_permission(30)) ;
            $data['sem_list'] = $this->Semester_model->get_all_sem();
            
            $data['_view'] = 'pages/unit/add';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Unit");
    }

    function info($unit_id)
    {
        $done = false;
        do {
            if (!$this->check_permission(50) ) break;
            $data['unit_id'] = $unit_id ;
            $real_unit_id = decode_id($unit_id);
            if (empty($real_unit_id)) break;
            $data['sem_list'] = $this->Semester_model->get_all_sem();
            $data['error_msg'] = '';

            $data['unit_info']=$this->Unit_model->get_unit_info($real_unit_id)[0];
            $data['unit_header']=$data['unit_info']->unit_code . ' - '. $data['unit_info']->unit_description;
            $data['_view'] = 'pages/unit/info';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Unit");
    }

    function edit($unit_id)
    {
        $done = false;
        do {
            if (!$this->check_permission(50) ) break;
            $data['unit_id'] = $unit_id ;
            $real_unit_id = decode_id($unit_id);
            if (empty($real_unit_id)) break;
            $data['unit_info']=$this->Unit_model->get_unit_info($real_unit_id)[0];
            $data['sem_list'] = $this->Semester_model->get_all_sem();
            $data['error_msg'] = '';
            if (isset($_POST['submit'])) {
                if ( $data['unit_info']->unit_code != strtoupper($this->input->post('unit_code')) || 
                     $data['unit_info']->sem != $this->input->post('sem') || 
                     $data['unit_info']->unit_description != $this->input->post('unit_desc')
                    ) 
                    {
                        if ($this->Unit_model->get_unit_id(strtoupper($this->input->post('unit_code')), $this->input->post('sem')) ) {
                            $data['error_msg'] = "Unit already exist in the system.";
                        }
                        else {
                            $data_param = array (
                                'unit_code' => strtoupper($this->input->post('unit_code')),
                                'sem' => $this->input->post('sem'),
                                'unit_description' => $this->input->post('unit_desc')
                            );
                            $this->Unit_model->update_unit($real_unit_id,$data_param);
                        }
                    }
            }

            $data['unit_info']=$this->Unit_model->get_unit_info($real_unit_id)[0];
            $data['unit_header']=$data['unit_info']->unit_code . ' - '. $data['unit_info']->unit_description;
            $data['_view'] = 'pages/unit/edit';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Unit");
    }

    function remove($unit_id)
    {
        $done = false;
        do {
            if (!$this->check_permission(50) ) break;
            $real_unit_id = decode_id($unit_id);
            if (empty($real_unit_id)) break;
            $this->Unit_model->delete_unit($real_unit_id);
        } while(0);

        if (!$done) redirect("Unit");
    }

    function enable_switch($unit_id)
    {
        $done = false;
        do {
            if (!$this->check_permission(50) ) break;
            $real_unit_id = decode_id($unit_id);
            if (empty($real_unit_id)) break;
            $this->Unit_model->enable_switch($real_unit_id);
        } while(0);

        if (!$done) redirect("Unit");
    }

}
