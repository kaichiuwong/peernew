<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Assignment extends MY_PasController {
    function __construct()
    {
        parent::__construct();
        $this->load->model('Assignment_model');
    } 

    /*
     * Listing of assignments
     */
    function index()
    {
        if ($this->check_permission(10)) {
            $data['assignments'] = $this->Assignment_model->get_all_assignments_student($this->get_login_user());
            $data['_view'] = 'pages/assignment/index';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
        }
    }

    /*
     * Editing a assignment
     */
    function info($asg_id)
    {
        if ($this->check_permission(10) ) {
            if ($this->is_allow_view_asg($asg_id)) {
                $data['asg_id'] = $asg_id;
                $data['assignment'] = $this->Assignment_model->get_assignment($asg_id);
                
                if(isset($data['assignment']['id']))
                {
                    $this->load->model('Unit_model');
                    $data['all_units'] = $this->Unit_model->get_all_units();
                    
                    $new_session_data = array('asg_id' => $asg_id, 'asg_header' => $data['assignment']['unit_code'] . ' - ' . $data['assignment']['title']);
                    $this->session->set_userdata($new_session_data);
                    
                    $data['_view'] = 'pages/assignment/info';
                    $this->load_header($data);
                    $this->load->view('templates/main',$data);
                    $this->load_footer($data);
                }
                else {
                    redirect('Assignment');
                }
            }
        }
    } 
    
    function group($asg_id)
    {
        if ($this->check_permission(10)) {
            if ($asg_id) {
                if ($this->is_allow_view_asg($asg_id)) {
                    $data['asg_id'] = $asg_id;
                    $data['_view'] = 'pages/assignment/group';
                    $this->load->model('Assignment_topic_model');
                    $data['assignment_topic'] = $this->Assignment_topic_model->get_assignment_topic_by_student($asg_id, $this->get_login_user() );
                    $data['selected_topic'] = false;
                    if(isset($data['assignment_topic']['topic_id'])) { $data['selected_topic'] = true; }
                    
                    $data['assignment_topics'] = $this->Assignment_topic_model->get_assignment_topic_by_asgid($asg_id);
                    $this->load_header($data);
                    $this->load->view('templates/main',$data);
                    $this->load_footer($data);
                }
            }
            else {
                redirect('Assignment');
            }
        }
    }
    
    function leave_group($asg_id, $topic_id) 
    {
        if ($this->check_permission(10)) {
            if ($asg_id && $topic_id) {
                if ($this->is_allow_view_asg($asg_id)) {
                    $this->load->model('Assignment_topic_model');
                    $this->Assignment_topic_model->leave_topic($asg_id, $this->get_login_user(),$topic_id );
                    redirect('Assignment/group/'.$asg_id);
                }
            }
            else {
                redirect('Assignment');
            }
        }
    }
    
    function join_group($asg_id, $topic_id) 
    {
        if ($this->check_permission(10)) {
            if ($asg_id && $topic_id) {
                if ($this->is_allow_view_asg($asg_id)) {
                    $this->load->model('Assignment_topic_model');
                    $this->Assignment_topic_model->join_topic($asg_id, $this->get_login_user(),$topic_id );
                    redirect('Assignment/group/'.$asg_id);
                }
            }
            else {
                redirect('Assignment');
            }
        }
    }
    
    function topic_member($id) 
    {
        if ($this->check_permission(10)) {
            $this->load->model('Assignment_topic_model');
            $data['assignment_topics'] = $this->Assignment_topic_model->get_assignment_member($id);
            $this->load->view('pages/assignment/group_member',$data);
        }
    }
    
    function submit($asg_id) {
        if ($this->check_permission(10) ) {
            if ($this->is_allow_view_asg($asg_id)) {
                $data['asg_id'] = $asg_id;
                $data['assignment'] = $this->Assignment_model->get_assignment($asg_id);
                
                if(isset($data['assignment']['id']))
                {
                    if (isset($_POST['asg_id'])) 
                    {
                        $config['upload_path'] = './uploads/'.md5($this->input->post('asg_id')).'/'.md5($this->input->post('grp_id')).'/';
                        $config['allowed_types'] = 'txt|rtf|pdf|docx|doc|ppt|pptx|xls|xlsx';
                        $config['file_ext_tolower'] = true;
                        $config['encrypt_name'] = true;

                        $this->load->library('upload', $config);
                        if (!is_dir($config['upload_path']))
                        {
                            mkdir($config['upload_path'], 0777, true);
                        }
                        $upload_result = $this->upload->do_upload('assignment_file');
                        if ($upload_result) {
                            $upload_data = $this->upload->data();
                            $this->load->model('Submission_model');
                            $this->Submission_model->delete_submission_by_group($this->input->post('asg_id'), $this->input->post('grp_id'));
                            $this->Submission_model->submit_assignment($this->input->post('asg_id'),
                                                                       $this->input->post('grp_id'),
                                                                       $this->input->post('username'),
                                                                       $config['upload_path'].$upload_data['file_name']);
                            redirect('Assignment/submit/'.$asg_id);
                        }
                        else {
                            echo $this->upload->display_errors();
                        }
                    }
                    else {
                        $data['username'] = $this->get_login_user();
                        
                        $this->load->model('Unit_model');
                        $data['all_units'] = $this->Unit_model->get_all_units();
                        
                        $this->load->model('Assignment_topic_model');
                        $data['assignment_topic'] = $this->Assignment_topic_model->get_assignment_topic_by_student($asg_id, $this->get_login_user() );
                        $data['allow_submit'] = false;
                        if(isset($data['assignment_topic']['topic_id'])) {
                            $data['allow_submit'] = true; 
                            $this->load->model('Submission_model');
                            $data['submission_hist'] = $this->Submission_model->get_submission_history_by_group($asg_id, $data['assignment_topic']['topic_id']);

                            $this->load->model('assignment_question_model');
                            $data['assignment_questions_peer'] = $this->assignment_question_model->get_assignment_question_by_asgid_section($asg_id,'PEER');
                            $data['assignment_questions_self'] = $this->assignment_question_model->get_assignment_question_by_asgid_section($asg_id,'SELF');
                        }
                        
                        $new_session_data = array('asg_id' => $asg_id, 'asg_header' => $data['assignment']['unit_code'] . ' - ' . $data['assignment']['title']);
                        $this->session->set_userdata($new_session_data);
                        
                        $data['_view'] = 'pages/assignment/submission';
                        $this->load_header($data);
                        $this->load->view('templates/main',$data);
                        $this->load_footer($data);
                    }
                }
                else {
                    redirect('Assignment');
                }
            }
        }
    }

}
