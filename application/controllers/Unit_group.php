<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Unit_group extends MY_PasController {
    function __construct()
    {
        parent::__construct();
        $this->load->model('Unit_model');
        $this->load->model('Semester_model');
        $this->load->model('Unit_group_model');
    } 
    
    function index($unit_id)
    {
        $done = false;
        do 
        {
            if (!$this->check_permission(50) ) break;
            $real_unit_id = decode_id($unit_id);
            if (empty($real_unit_id)) break;
            $data['unit_id'] = $unit_id;
            $data['unit_info']=$this->Unit_model->get_unit_info($real_unit_id)[0];
            $data['unit_header']=$data['unit_info']->unit_code . ' - '. $data['unit_info']->unit_description;
            $data['unit_set'] = $this->Unit_group_model->get_unit_set_stat($real_unit_id);
            $data['_view'] = 'pages/unit_group/index';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Unit");
    }

    function add($unit_id)
    {
        $done = false;
        do 
        {
            if (!$this->check_permission(50) ) break;
            $real_unit_id = decode_id($unit_id);
            if (empty($real_unit_id)) break;
            $data['unit_id'] = $unit_id;
            $data['unit_info']=$this->Unit_model->get_unit_info($real_unit_id)[0];
            $data['unit_header']=$data['unit_info']->unit_code . ' - '. $data['unit_info']->unit_description;
            $data['error_msg'] = "";
            if (isset($_POST['submit'])) {
                $new_set_id = $this->Unit_group_model->create_unit_set($real_unit_id, 
                       $this->input->post('group_num'), 
                       $this->input->post('max'), 
                       $this->input->post('title'), 
                       $this->input->post('prefix') );
                if (!empty($new_set_id)) break;
            }

            $data['_view'] = 'pages/unit_group/add';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Unit_group/index/".$unit_id);
    }

    function remove($unit_id,$set_id)
    {
        $done = false;
        do {
            if (!$this->check_permission(50) ) break;
            $real_set_id = decode_id($set_id);
            if (empty($real_set_id)) break;
            $this->Unit_group_model->remove_set($real_set_id);
        } while(0);

        if (!$done) redirect("Unit_group/index/".$unit_id);
    }

}
