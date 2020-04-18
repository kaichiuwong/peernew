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
        if ($this->check_permission(50) ) {
            $done = false;
            do 
            {
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
    }

    function remove($unit_id,$set_id)
    {
        if ($this->check_permission(50) ) {
            $done = false;
            do {
                $real_set_id = decode_id($set_id);
                if (empty($real_set_id)) break;
                $this->Unit_group_model->remove_set($real_set_id);
            } while(0);

            if (!$done) redirect("Unit_group/index/".$unit_id);
        }
    }

    function group($unit_id,$set_id)
    {
        if ($this->check_permission(50) ) {
            $done = false;

            do 
            {
                $real_unit_id = decode_id($unit_id);
                $real_set_id = decode_id($set_id);
                if (empty($real_unit_id)) break;
                $data['unit_id'] = $unit_id;
                $data['set_id'] = $set_id;
                $data['unit_info']=$this->Unit_model->get_unit_info($real_unit_id)[0];
                $data['unit_header']=$data['unit_info']->unit_code . ' - '. $data['unit_info']->unit_description;
                $data['group_list'] = $this->Unit_group_model->get_group_by_set($real_set_id);
                $data['student_no_grp'] = $this->Unit_group_model->get_student_without_group($real_unit_id, $real_set_id);
                $data['set_info'] = $this->Unit_group_model->get_unit_set($real_set_id)[0];
                
                $data['_view'] = 'pages/unit_group/group';
                $this->load_header($data);
                $this->load->view('templates/main',$data);
                $this->load_footer($data);
                $done = true;
            } while(0);

            if (!$done) redirect("Unit_group/index/".$unit_id);
        }
    }

    function add_group($unit_id, $set_id)
    {
        $done = false;
        do 
        {
            if (!$this->check_permission(50) ) break;
            $real_unit_id = decode_id($unit_id);
            $real_set_id = decode_id($set_id);
            if (empty($real_unit_id)) break;
            $data['unit_id'] = $unit_id;
            $data['set_id'] = $set_id;
            $data['unit_info']=$this->Unit_model->get_unit_info($real_unit_id)[0];
            $data['set_info'] = $this->Unit_group_model->get_unit_set($real_set_id)[0];
            $data['unit_header']=$data['unit_info']->unit_code . ' - '. $data['unit_info']->unit_description;
            $data['error_msg'] = "";
            if (isset($_POST['submit'])) {
                $this->Unit_group_model->bulk_create_unit_group($real_set_id, 
                       $this->input->post('group_num'), 
                       $this->input->post('max'), 
                       $this->input->post('prefix') );
                break;
            }

            $data['_view'] = 'pages/unit_group/add_group';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Unit_group/group/".$unit_id.'/'.$set_id);
    }

    function random($unit_id, $set_id)
    {
        $done = false;
        do {
            if (!$this->check_permission(50) ) break;
            $real_unit_id = decode_id($unit_id);
            $real_set_id = decode_id($set_id);
            if (empty($real_unit_id)) break;
            if (empty($real_set_id)) break;
            $this->Unit_group_model->random_assign($real_unit_id, $real_set_id);
        } while(0);

        if (!$done) redirect("Unit_group/group/".$unit_id.'/'.$set_id);
    }

    function remove_group($unit_id, $set_id, $grp_id)
    {
        $done = false;
        do {
            if (!$this->check_permission(50) ) break;
            $real_grp_id = decode_id($grp_id);
            if (empty($real_grp_id)) break;
            $this->Unit_group_model->remove_group($real_grp_id);
        } while(0);

        if (!$done) redirect("Unit_group/group/".$unit_id.'/'.$set_id);
    }

    function group_member($grp_id) 
    {
        if ($this->check_permission(50)) {
            $real_grp_id = decode_id($grp_id);
            $data['assignment_topics'] = $this->Unit_group_model->get_group_member($real_grp_id);
            $this->load->view('pages/unit_group/group_member',$data);
        }
    }

    function student_no_group($unit_id, $set_id)
    {
        if ($this->check_permission(50)) {
            $real_unit_id = decode_id($unit_id);
            $real_set_id = decode_id($set_id);
            if (!empty($real_unit_id) && !empty($real_set_id)) {
                $data['assignment_topics'] = $this->Unit_group_model->get_student_without_group($real_unit_id, $real_set_id);
                $this->load->view('pages/unit_group/group_member',$data);
            }
        }
    }

    function clear_allocation($unit_id, $set_id)
    {
        $done = false;
        do {
            if (!$this->check_permission(50) ) break;
            $real_set_id = decode_id($set_id);
            if (empty($real_set_id)) break;
            $this->Unit_group_model->clear_allocation($real_set_id);
        } while(0);

        if (!$done) redirect("Unit_group/group/".$unit_id.'/'.$set_id);
    }

    function clear_groups($unit_id, $set_id)
    {
        $done = false;
        do {
            if (!$this->check_permission(50) ) break;
            $real_set_id = decode_id($set_id);
            if (empty($real_set_id)) break;
            $this->Unit_group_model->clear_groups($real_set_id);
        } while(0);

        if (!$done) redirect("Unit_group/group/".$unit_id.'/'.$set_id);
    }


    function student_list($unit_id, $set_id)
    {
        $done = false;

        do 
        {
            if (!$this->check_permission(50) ) break;
            $real_unit_id = decode_id($unit_id);
            $real_set_id = decode_id($set_id);
            if (empty($real_unit_id)) break;
            $data['unit_id'] = $unit_id;
            $data['set_id'] = $set_id;
            $data['unit_info']=$this->Unit_model->get_unit_info($real_unit_id)[0];
            $data['set_info'] = $this->Unit_group_model->get_unit_set($real_set_id)[0];
            $data['unit_header']=$data['unit_info']->unit_code . ' - '. $data['unit_info']->unit_description;

            $data['_view'] = 'pages/unit_group/list';
            $data['students'] = $this->Unit_group_model->get_unit_groups_allocation_set($real_unit_id, $real_set_id);
            $data['group_list'] = $this->Unit_group_model->get_unit_groups_allocation_stat($real_set_id);
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Unit_group/group/".$unit_id.'/'.$set_id);
    }

    function assign_grp()
    {
        header('Content-Type: application/json');
        $done = false;
        $http_code = 500;
        $grp_info = null;
        $msg = "";
        do {
            if (!$this->check_permission(50, false) ) break;
            if (!isset($_POST['set_id'])) break;
            if (!isset($_POST['user_id'])) break;
            if (!isset($_POST['old_grp_id'])) break;
            if (!isset($_POST['group_id'])) break;            
            $real_set_id = decode_id($this->input->post('set_id'));
            if (empty($real_set_id)) break;
            $grp_info = $this->Unit_group_model->assign_group($this->input->post('user_id'),$this->input->post('old_grp_id'),$this->input->post('group_id'));
            if ($grp_info) {
                $done = true;
                $http_code = 200;
            }
            else {
                $msg = "Full Group";
            }
        } while(0);

        return $this->output
            ->set_content_type('application/json')
            ->set_status_header($http_code)
            ->set_output( json_encode( array_merge($grp_info, array('status' => $done, 'message'=>$msg)) ) );
    }

    function grp_list_html($set_id, $selected = null)
    {
        $done = false;
        do 
        {
            if (!$this->check_permission(50, false) ) break;
            $real_set_id = decode_id($set_id);
            if (empty($real_set_id)) break;
            $data['set_id'] = $set_id;
            $data['selected_id'] = $selected;
            $data['group_list'] = $this->Unit_group_model->get_unit_groups_allocation_stat($real_set_id);
            $this->load->view('pages/unit_group/grp_list',$data);
            $done = true;
        } while(0);
    }
}
