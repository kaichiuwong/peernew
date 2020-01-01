<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Assignmentadmin extends MY_PasController {
    function __construct()
    {
        parent::__construct();
        $this->load->model('Assignment_model');
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
        if ($this->check_permission(30) ) {
            $data['asg_id'] = $asg_id;
            $data['assignment'] = $this->Assignment_model->get_assignment($asg_id);
            
            if(isset($data['assignment']['id']))
            {
                $new_session_data = array('asg_id' => $asg_id, 'asg_header' => $data['assignment']['unit_code'] . ' - ' . $data['assignment']['title']);
                $this->session->set_userdata($new_session_data);
                
                $data['_view'] = 'pages/assignmentadmin/info';
                $this->load_header($data);
                $this->load->view('templates/main',$data);
                $this->load_footer($data);
            }
            else {
                redirect('Assignment');
            }
        }
    } 

    function add()
    {
        if ($this->check_permission(30)) {
            $this->load->library('form_validation');

            $this->form_validation->set_rules('type','Assignment Type','required');
            $this->form_validation->set_rules('unit_id','Unit','required');
            $this->form_validation->set_rules('group_num','Number of Group','required');
            $this->form_validation->set_rules('max','Max number per group','required');
            $this->form_validation->set_rules('title','Title','max_length[500]');
            
            if($this->form_validation->run())     
            {   
                $params = array(
                    'type' => $this->input->post('type'),
                    'unit_id' => $this->input->post('unit_id'),
                    'title' => $this->input->post('title'),
                    'outcome' => $this->input->post('outcome'),
                    'scenario' => $this->input->post('scenario'),
                );
                
                $assignment_id = $this->Assignment_model->add_assignment($params);
                if ($assignment_id) {
                    $this->load->model('Assignment_topic_model');
                    
                    $this->Assignment_topic_model->bulk_add_assignment_topic(
                            $assignment_id, 
                            $this->input->post('group_num'), 
                            $this->input->post('max'),
                            $this->input->post('prefix')
                    );

                    $this->load->model('Assignment_date_model');
                    $this->Assignment_date_model->add_default($assignment_id, $this->get_login_user() );
                }
                redirect('Assignmentadmin/index');
            }
            else
            {
                $this->load->model('Unit_model');
                $data['all_units'] = $this->Unit_model->get_all_units();
                
                $data['_view'] = 'pages/assignmentadmin/add';
                $this->load_header($data);
                $this->load->view('templates/main',$data);
                $this->load_footer($data);
            }
        }
    }  

    function edit($asg_id)    {
        if ($this->check_permission(30)) {
            $data['asg_id'] = $asg_id;
            // check if the assignment exists before trying to edit it
            $data['assignment'] = $this->Assignment_model->get_assignment($asg_id);
            
            if(isset($data['assignment']['id']))
            {
                $this->load->library('form_validation');

                $this->form_validation->set_rules('type','Type','required');
                $this->form_validation->set_rules('unit_id','Unit Id','required');
                $this->form_validation->set_rules('title','Title','max_length[500]');
            
                if($this->form_validation->run())     
                {   
                    $params = array(
                        'type' => $this->input->post('type'),
                        'unit_id' => $this->input->post('unit_id'),
                        'title' => $this->input->post('title'),
                        'outcome' => $this->input->post('outcome'),
                        'scenario' => $this->input->post('scenario'),
                    );

                    $this->Assignment_model->update_assignment($asg_id,$params);            
                    redirect('Assignmentadmin/info/'.$asg_id);
                }
                else
                {
                    $this->load->model('Unit_model');
                    $data['all_units'] = $this->Unit_model->get_all_units();
                    
                    $new_session_data = array('asg_id' => $asg_id, 'asg_header' => $data['assignment']['unit_code'] . ' - ' . $data['assignment']['title']);
                    $this->session->set_userdata($new_session_data);
                    
                    $data['_view'] = 'pages/assignmentadmin/edit';
                    $this->load_header($data);
                    $this->load->view('templates/main',$data);
                    $this->load_footer($data);
                }
            }
            else
                show_error('The assignment you are trying to edit does not exist.');
        }
    } 

    function remove($asg_id)
    {
        if ($this->check_permission(30)) {
            $data['asg_id'] = $asg_id;
            $assignment = $this->Assignment_model->get_assignment($asg_id);

            // check if the assignment exists before trying to delete it
            if(isset($assignment['id']))
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
