<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Assignment extends MY_PasController {
    function __construct()
    {
        parent::__construct();
        $this->load->model('Assignment_model');
    } 
    
    function index()
    {
        if ($this->check_permission(10)) {
            $data['assignments'] = $this->Assignment_model->get_all_assignments_student($this->get_login_user(), $this->current_sem());
            $data['_view'] = 'pages/assignment/index';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
        }
    }

    function info($asg_id)
    {
        if ($this->check_permission(10) ) {
            if ($this->is_allow_view_asg(decode_id($asg_id))) {
                $data['asg_id'] = $asg_id;
                $data['assignment'] = $this->Assignment_model->get_assignment(decode_id($asg_id));
                
                if(isset($data['assignment']['id']))
                {
                    $data['assignment']['id'] = encode_id($data['assignment']['id']);
                    $this->load->model('Unit_model');
                    $data['all_units'] = $this->Unit_model->get_all_units();
                    $this->load->model('Assignment_date_model');
                    $data['Assignment_dates'] = $this->Assignment_date_model->get_all_dates_by_asg_id(decode_id($asg_id));
                    
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
                if ($this->is_allow_view_asg(decode_id($asg_id))) {
                    $data['asg_id'] = $asg_id;
                    $data['submission_condition']  = $this->is_open(decode_id($asg_id),'GRP_OPEN','GRP_CLOSE', false);
                    $data['_view'] = 'pages/assignment/group';
                    $this->load->model('Assignment_topic_model');
                    $data['assignment_topic'] = $this->Assignment_topic_model->get_assignment_topic_by_student(decode_id($asg_id), $this->get_login_user() );
                    $data['selected_topic'] = false;
                    if(isset($data['assignment_topic']['topic_id'])) { $data['selected_topic'] = true; }
                    
                    $data['assignment_topics'] = $this->Assignment_topic_model->get_assignment_topic_by_asgid(decode_id($asg_id));
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
                if ($this->is_allow_view_asg(decode_id($asg_id))) {
                    $data['submission_condition']  = $this->is_open(decode_id($asg_id),'GRP_OPEN','GRP_CLOSE', false);
                    if ($data['submission_condition']['result']) {
                        $this->load->model('Assignment_topic_model');
                        $this->Assignment_topic_model->leave_topic(decode_id($asg_id), $this->get_login_user(),$topic_id );
                    }
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
                if ($this->is_allow_view_asg(decode_id($asg_id))) {
                    $data['submission_condition']  = $this->is_open(decode_id($asg_id),'GRP_OPEN','GRP_CLOSE', false);
                    if ($data['submission_condition']['result']) {
                        $this->load->model('Assignment_topic_model');
                        $this->Assignment_topic_model->join_topic(decode_id($asg_id), $this->get_login_user(),$topic_id );
                    }
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

    function asg_upload_form($asg_id, $topic_id) {
        if ($this->check_permission(10) ) {
            if ($this->is_allow_view_asg(decode_id($asg_id))) {
                $data['asg_id'] = $asg_id;
                $data['submission_condition']  = $this->is_open(decode_id($asg_id),'SUBMISSION_OPEN','SUBMISSION_CLOSE', false);
                if ($data['submission_condition']["result"]) {
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
                            $this->Submission_model->delete_submission_by_group(decode_id($this->input->post('asg_id')), $this->input->post('grp_id'));
                            $this->Submission_model->submit_assignment(decode_id($this->input->post('asg_id')),
                                                                        $this->input->post('grp_id'),
                                                                        $this->input->post('username'),
                                                                        $config['upload_path'].$upload_data['file_name']);
                        }
                        else {
                            echo $this->upload->display_errors();
                        }
                    }
                }
                $this->load->model('Assignment_date_model');
                $data['asg_deadline'] = $this->Assignment_date_model->get_date_by_asg_id_key(decode_id($asg_id), 'SUBMISSION_DEADLINE');
                $data['username'] = $this->get_login_user();
                
                $this->load->model('Unit_model');
                $data['all_units'] = $this->Unit_model->get_all_units();
                
                $this->load->model('Assignment_topic_model');
                $data['assignment_topic'] = $this->Assignment_topic_model->get_assignment_topic_by_student(decode_id($asg_id), $this->get_login_user() );
                $data['allow_submit'] = false;
                if(isset($data['assignment_topic']['topic_id'])) {
                    $data['allow_submit'] = true; 
                    $this->load->model('Submission_model');
                    $data['submission_hist'] = $this->Submission_model->get_submission_history_by_group(decode_id($asg_id), $data['assignment_topic']['topic_id']);
                }
                $this->load->view('pages/assignment/asg_submission_form',$data);
            }
        }
    }

    function self_feedback_form($asg_id, $topic_id) {
        if ($this->check_permission(10) ) {
            if ($this->is_allow_view_asg(decode_id($asg_id))) {
                $data['submission_condition']  = ($this->is_open(decode_id($asg_id),'SELF_REVIEW_OPEN','SELF_REVIEW_CLOSE', false));

                $this->load->model('assignment_feedback_model');
                if ($data['submission_condition']['result']) {
                    if (isset($_POST['asg_id']) && isset($_POST['topic_id'])) 
                    {
                        $post_asg_id = decode_id($this->input->post('asg_id'));
                        $post_topic_id = $this->input->post('topic_id');
                        $post_reviewer = $this->input->post('reviewer');
                        $post_reviewee = $this->input->post('reviewee');
                        $post_qid_array = $this->input->post('question_id');
                        foreach ($post_qid_array as $qid) {
                            if (isset($_POST['self_feedback_'. $qid])) {

                                $feedback = trim($this->input->post('self_feedback_'. $qid));
                                $feedback_id = $this->input->post('self_feedback_id_'. $qid);
                                if ($feedback == "" && $feedback_id == "") {
                                }
                                else{
                                    $params = array(
                                        "asg_id" => $post_asg_id,
                                        "question_id" => $qid,
                                        "reviewer" => $post_reviewer,
                                        "reviewee" => $post_reviewee,
                                        "feedback" => $feedback
                                    );
                                    if (!empty($feedback_id)) {
                                        $this->assignment_feedback_model->update_assignment_feedback($feedback_id, $params);
                                    }
                                    else {
                                        $this->assignment_feedback_model->add_assignment_feedback($params);
                                    }
                                }
                            }
                        }
                    }
                }
                $data['asg_id'] = $asg_id;
                $data['topic_id'] = $topic_id;
                $data['username'] = $this->get_login_user();
                $this->load->model('assignment_question_model');                
                $data['assignment_questions_self'] = $this->assignment_feedback_model->get_question_with_feedback(decode_id($asg_id),$this->get_login_user(),$this->get_login_user(),'SELF');
                $this->load->view('pages/assignment/self_feedback_form',$data);
            }
        }
    }

    function peer_feedback_form($asg_id, $topic_id) {
        if ($this->check_permission(10) ) {
            if ($this->is_allow_view_asg(decode_id($asg_id))) {
                $data['submission_condition'] = ($this->is_open(decode_id($asg_id),'PEER_REVIEW_OPEN','PEER_REVIEW_CLOSE', false));

                $this->load->model('assignment_feedback_model');
                if ($data['submission_condition']['result']) {
                    if (isset($_POST['asg_id']) && isset($_POST['topic_id'])) 
                    {
                        $post_asg_id = decode_id($this->input->post('asg_id'));
                        $post_topic_id = $this->input->post('topic_id');
                        $post_reviewer = $this->input->post('reviewer');
                        $post_reviewee_array = $this->input->post('reviewee');
                        $post_qid_array = $this->input->post('question_id');
                        foreach ($post_qid_array as $qid) {
                            foreach ($post_reviewee_array as $reviewee) {
                                if (isset($_POST['feedback_'.$reviewee.'_'.$qid])) {
                                    $feedback = trim($this->input->post('feedback_'.$reviewee.'_'.$qid));
                                    $feedback_id = $this->input->post('feedback_id_'.$reviewee.'_'.$qid);
                                    if ($feedback == "" && $feedback_id == "") {
                                    }
                                    else{
                                        $params = array(
                                            "asg_id" => $post_asg_id,
                                            "question_id" => $qid,
                                            "reviewer" => $post_reviewer,
                                            "reviewee" => $reviewee,
                                            "feedback" => $feedback
                                        );
                                        if (!empty($feedback_id)) {
                                            $this->assignment_feedback_model->update_assignment_feedback($feedback_id, $params);
                                        }
                                        else {
                                            $this->assignment_feedback_model->add_assignment_feedback($params);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                $data['asg_id'] = $asg_id;
                $data['topic_id'] = $topic_id;
                $data['username'] = $this->get_login_user();
                $this->load->model('assignment_question_model');
                $this->load->model('Assignment_topic_model');
                $data['assignment_topics_member'] = $this->Assignment_topic_model->get_assignment_member($topic_id);
                foreach($data['assignment_topics_member'] as $member) {
                    $data['assignment_questions_peer'][$member['user_id']] = $this->assignment_feedback_model->get_question_with_feedback(decode_id($asg_id),$this->get_login_user(),$member['user_id'],'PEER');
                }
                $this->load->view('pages/assignment/peer_feedback_form',$data);
            }
        }
    }
    
    function submit($asg_id) {
        if ($this->check_permission(10) ) {
            if ($this->is_allow_view_asg(decode_id($asg_id))) {
                $data['asg_id'] = $asg_id;
                $data['assignment'] = $this->Assignment_model->get_assignment(decode_id($asg_id));
                
                if(isset($data['assignment']['id']))
                {
                    $data['username'] = $this->get_login_user();
                    $this->load->model('Assignment_topic_model');
                    $data['assignment_topic'] = $this->Assignment_topic_model->get_assignment_topic_by_student(decode_id($asg_id), $this->get_login_user() );
                    $data['allow_submit'] = false;
                    if(isset($data['assignment_topic']['topic_id'])) {
                        $data['allow_submit'] = true; 
                    }
                    
                    $new_session_data = array('asg_id' => $asg_id, 'asg_header' => $data['assignment']['unit_code'] . ' - ' . $data['assignment']['title']);
                    $this->session->set_userdata($new_session_data);
                    
                    $data['_view'] = 'pages/assignment/submission';
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

}
