<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Assignmentadmin extends MY_PasController {
    function __construct()
    {
        parent::__construct();
        $this->load->model('Assignment_model');
        $this->load->model('Unit_group_model');
    } 

    function index($unit_code = null)
    {
        if ($this->check_permission(30)) {
            if ($this->check_permission(90, false)) 
            {
                $data['assignments'] = $this->Assignment_model->get_all_assignments();
            }
            else 
            {
                $data['assignments'] = $this->Assignment_model->get_all_assignments($this->get_login_user());
            }
            $data['_view'] = 'pages/assignmentadmin/index';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
        }
    }

    function info($asg_id)
    {
        $done = false;

        do 
        {
            if (!$this->check_permission(30) ) break;
            $asg_result = $this->assignment_check($asg_id, false);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['assignment'] = $asg_result['asg_info'];
            $data['asg_header'] = $asg_result['asg_header'];

            $data['asg_id'] = $asg_id;
            $data['assignment'] = $this->Assignment_model->get_assignment($asg_id);    
            $data['_view'] = 'pages/assignmentadmin/info';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Assignmentadmin");
    } 

    function add($unit_id)
    {
        if ($this->check_permission(30)) {

            if(isset($_POST['submit']))
            {   
                $params = array(
                    'type' => $this->input->post('type'),
                    'unit_id' => decode_id($this->input->post('unit_id')),
                    'title' => $this->input->post('title'),
                    'outcome' => $this->input->post('outcome'),
                    'scenario' => $this->input->post('scenario'),
                );
                
                $assignment_id = $this->Assignment_model->add_assignment($params);
                if ($assignment_id) {
                    $this->load->model('Assignment_date_model');
                    $this->Assignment_date_model->add_default($assignment_id, $this->get_login_user() );

                    $this->load->model('Assignment_feedback_model');
                    $this->Assignment_feedback_model->add_default_feedback($assignment_id, $this->get_login_user() );

                    if (!empty($_POST['group_set'] ) ) {
                        $this->load->model('Unit_group_model');
                        $this->Unit_group_model->transfer_set_to_assignment($this->input->post('group_set'), $assignment_id);
                    }
                    
                }
                redirect('Assignmentadmin/index');
            }
            else
            {
                $real_unit_id = decode_id($unit_id);
                if (!empty($real_unit_id)) {
                    $this->load->model('Unit_model');
                    $data['unit_set'] = $this->Unit_group_model->get_unit_set_stat($real_unit_id);
                    $data['real_unit_id'] = $real_unit_id;
                    $data['unit_id'] = $unit_id;
                    $data['unit_info']=$this->Unit_model->get_unit_info($real_unit_id)[0];
                    $data['unit_header']=$data['unit_info']->unit_code . ' - '. $data['unit_info']->unit_description;
                    
                    $data['_view'] = 'pages/assignmentadmin/add';
                    $this->load_header($data);
                    $this->load->view('templates/main',$data);
                    $this->load_footer($data);
                }
                else {
                    redirect('Assignmentadmin/index');
                }
            }
        }
    }  

    function edit($asg_id)    {
        $done = false;

        do 
        {
            if (!$this->check_permission(30) ) break;
            $asg_result = $this->assignment_check($asg_id, false);
            if (!$asg_result['result']) break;

            if (isset($_POST['asg_id'])) {
                $params = array(
                    'title' => $this->input->post('title'),
                    'outcome' => $this->input->post('outcome'),
                    'scenario' => $this->input->post('scenario')
                );

                $this->Assignment_model->update_assignment($asg_id,$params);            
                redirect('Assignmentadmin/info/'.$asg_id);
            }
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['assignment'] = $asg_result['asg_info'];
            $data['asg_header'] = $asg_result['asg_header'];

            $data['asg_id'] = $asg_id;
            $data['assignment'] = $this->Assignment_model->get_assignment($asg_id);    
            $this->load->model('Unit_model');
            $data['all_units'] = $this->Unit_model->get_all_units();
            $data['_view'] = 'pages/assignmentadmin/edit';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);

            $done = true;
        } while(0);

        if (!$done) redirect("Assignmentadmin");
    } 

    function remove($asg_id)
    {
        if ($this->check_permission(30)) {
            $data['asg_id'] = $asg_id;
            $assignment = $this->Assignment_model->get_assignment($asg_id);

            // check if the assignment exists before trying to delete it
            if(isset($assignment['asg_id']))
            {
                $this->Assignment_model->delete_assignment($asg_id);
                redirect('Assignmentadmin/index/');
            }
            else
                show_error('The assignment you are trying to delete does not exist.');
        }
    }

    function public_switch($asg_id)
    {
        if ($this->check_permission(30)) {
            if (!empty($asg_id)) {
                $this->Assignment_model->public_switch($asg_id);
            }
        }
        redirect('Assignmentadmin');
    }
}
