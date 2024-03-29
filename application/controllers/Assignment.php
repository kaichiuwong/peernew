<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Assignment extends MY_PasController {
    function __construct()
    {
        parent::__construct();
        $this->load->model('Assignment_model');
        $this->load->model('Unit_model');
        $this->load->model('Assignment_date_model');
        $this->load->model('Assignment_topic_model');
        $this->load->model('Submission_model');
        $this->load->model('Assignment_question_model');
        $this->load->model('Assignment_feedback_model');
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

    function info($asg_id = null)
    {
        $done = false;
        do 
        {
            if (!$this->check_permission(10) ) break;
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
    
    function group($asg_id = null)
    {
        $done = false;
        do 
        {
            if (!$this->check_permission(10) ) break;
            $asg_result = $this->assignment_check($asg_id);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['assignment'] = $asg_result['asg_info'];
            $data['asg_header'] = $asg_result['asg_header'];

            $data['asg_id'] = $asg_id;
            $data['submission_condition']  = $this->is_open($decode_asg_id,'GRP_OPEN','GRP_CLOSE', false);
            $data['_view'] = 'pages/assignment/group';
            $data['assignment_topic'] = $this->Assignment_topic_model->get_assignment_topic_by_student($decode_asg_id, $this->get_login_user() );
            $data['selected_topic'] = false;
            if(isset($data['assignment_topic']['topic_id'])) { $data['selected_topic'] = true; }
            $data['assignment_topics'] = $this->Assignment_topic_model->get_assignment_topic_by_asgid($decode_asg_id);
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Assignment");
    }

    function feedback($asg_id = null)
    {
        $done = false;
        do 
        {
            if (!$this->check_permission(10) ) break;
            if (empty($asg_id)) break;
            $asg_result = $this->assignment_check($asg_id);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['assignment'] = $asg_result['asg_info'];
            $data['asg_header'] = $asg_result['asg_header'];
            $username = $this->get_login_user();
            $data['asg_id'] = $asg_id;
            $data['username'] = $username;

            $data['feedback_released'] = $this->Assignment_model->is_feedback_release($decode_asg_id);
            if ($data['feedback_released']) {
                $data['summary'] = $this->Submission_model->get_peer_review_summary($decode_asg_id,$username);
                $data['indiv_score'] = ($data['summary'][0]['override_score'] != NULL)? $data['summary'][0]['override_score']:$data['summary'][0]['peer_average'] ;
                $data['indiv_var'] = $data['summary'][0]['peer_var'] ;
                $data['group_score'] = $data['summary'][0]['group_score'] ;
                $data['total_score'] = $data['group_score'] + $data['indiv_score'] ;
                $data['indiv_default_feedback'] = ($data['indiv_score'] === null)?'':$this->Assignment_feedback_model->get_default_feedback($decode_asg_id, 'PEER', $data['indiv_score'])['feedback'];
                $data['indiv_var_default_feedback'] = ($data['indiv_var'] === null)?'':$this->Assignment_feedback_model->get_default_feedback($decode_asg_id, 'PEER_VARIANCE', $data['indiv_var'])['feedback'];
                $data['indiv_custom_feedback'] = $data['summary'][0]['override_score_remark'] ;
                $data['group_default_feedback'] = ($data['group_score'] === null)?'':$this->Assignment_feedback_model->get_default_feedback($decode_asg_id, 'GROUP', $data['group_score'])['feedback'];
                $data['group_custom_feedback'] = $data['summary'][0]['group_remark'] ;
                $data['feedback'] = sprintf("%s %s %s %s %s", 
                                    $data['group_default_feedback'],
                                    $data['group_custom_feedback'],
                                    $data['indiv_default_feedback'],
                                    $data['indiv_var_default_feedback'],
                                    $data['indiv_custom_feedback']
                                    );
            }
            $data['_view'] = 'pages/assignment/feedback';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Assignment");
    }

    function submit($asg_id= null) 
    {
        $done = false;

        do 
        {
            if (!$this->check_permission(10) ) break;
            $asg_result = $this->assignment_check($asg_id);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['assignment'] = $asg_result['asg_info'];
            $data['asg_header'] = $asg_result['asg_header'];

            $data['asg_id'] = $asg_id;
            $data['username'] = $this->get_login_user();
            $data['assignment_topic'] = $this->Assignment_topic_model->get_assignment_topic_by_student(decode_id($asg_id), $this->get_login_user() );
            $data['allow_submit'] = false;
            if(isset($data['assignment_topic']['topic_id'])) {
                $data['allow_submit'] = true; 
            }            
            $data['_view'] = 'pages/assignment/submission';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Assignment");
    }
    
    function leave_group($asg_id = null, $topic_id = null) 
    {
        $done = false;
        do 
        {
            if (!$this->check_permission(10) ) break;
            if (empty($topic_id)) break;
            $asg_result = $this->assignment_check($asg_id);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];

            $data['submission_condition']  = $this->is_open($decode_asg_id,'GRP_OPEN','GRP_CLOSE', false);
            if ($data['submission_condition']['result']) {
                $this->Assignment_topic_model->leave_topic($decode_asg_id, $this->get_login_user(),decode_id($topic_id) );
            }
            redirect('Assignment/group/'.$asg_id);
        } while(0);

        if (!$done) redirect("Assignment");
    }
    
    function join_group($asg_id = null, $topic_id = null) 
    {
        $done = false;
        do 
        {
            if (!$this->check_permission(10) ) break;
            if (empty($topic_id)) break;
            $asg_result = $this->assignment_check($asg_id);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];

            $data['submission_condition']  = $this->is_open(decode_id($asg_id),'GRP_OPEN','GRP_CLOSE', false);
            if ($data['submission_condition']['result']) {
                $this->Assignment_topic_model->join_topic(decode_id($asg_id), $this->get_login_user(),decode_id($topic_id) );
            }
            redirect('Assignment/group/'.$asg_id);
        } while(0);

        if (!$done) redirect("Assignment");
    }
    
    function topic_member($topic_id = null) 
    {
        do
        {
            if (!$this->check_permission(10) ) break;
            if (empty($topic_id)) break;
            $data['assignment_topics'] = $this->Assignment_topic_model->get_assignment_member(decode_id($topic_id));
            $this->load->view('pages/assignment/group_member',$data);
        } while(0);
    }

    function peer_self_review($asg_id = null, $group_id = null, $username = null)
    {
        do 
        {
            if (!$this->check_permission(10, false) ) break;
            if (empty($asg_id) || empty($group_id) || empty($username)) break;
            $asg_result = $this->assignment_check($asg_id);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['asg_id'] = $asg_id;
            $data['group_id'] = $group_id;
            $data['username'] = $username;

            $data['assignment_questions_self'] = $this->Assignment_feedback_model->get_question_with_feedback($decode_asg_id,decode_id($username),decode_id($username),'SELF');
            $this->load->view('pages/assignment/peer_self_review',$data);
        } while(0);
    }

    function asg_upload_form($asg_id = null, $topic_id = null) {
        do{
            if (!$this->check_permission(10) ) break;
            if (empty($topic_id)) break;
            $asg_result = $this->assignment_check($asg_id);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['assignment'] = $asg_result['asg_info'];

            $data['asg_id'] = $asg_id;
            $data['submission_condition']  = $this->is_open($decode_asg_id,'SUBMISSION_OPEN','SUBMISSION_CLOSE', false);
            if (isset($_POST['asg_id']) && isset($_POST['grp_id'])) 
            {
                do {
                    if (!$data['submission_condition']["result"]) break;
                    $config['upload_path'] = './uploads/'.$this->input->post('asg_id').'/'.$this->input->post('grp_id').'/';
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
                        $this->Submission_model->delete_submission_by_group(decode_id($this->input->post('asg_id')), decode_id($this->input->post('grp_id')));
                        $this->Submission_model->submit_assignment(decode_id($this->input->post('asg_id')),
                                                                decode_id( $this->input->post('grp_id')),
                                                                decode_id( $this->input->post('username')),
                                                                    $config['upload_path'].$upload_data['file_name']);
                    }
                    else {
                        echo $this->upload->display_errors();
                    }
                } while (0);
            }
            else
            {
                $data['asg_deadline'] = $this->Assignment_date_model->get_date_by_asg_id_key($decode_asg_id, 'SUBMISSION_DEADLINE');
                $data['username'] = $this->get_login_user();
                $data['all_units'] = $this->Unit_model->get_all_units();
                $data['assignment_topic'] = $this->Assignment_topic_model->get_assignment_topic_by_student($decode_asg_id, $this->get_login_user() );
                $data['allow_submit'] = false;
                if(isset($data['assignment_topic']['topic_id'])) {
                    $data['allow_submit'] = true; 
                    $data['submission_hist'] = $this->Submission_model->get_submission_history_by_group($decode_asg_id, $data['assignment_topic']['topic_id']);
                }
                $this->load->view('pages/assignment/asg_submission_form',$data);
            }
        } while(0);
    }

    function self_feedback_form($asg_id = null , $topic_id = null) {
        do
        {
            if (!$this->check_permission(10) ) break;
            if (empty($topic_id)) break;
            $asg_result = $this->assignment_check($asg_id);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['assignment'] = $asg_result['asg_info'];

            $data['submission_condition']  = ($this->is_open($decode_asg_id,'SELF_REVIEW_OPEN','SELF_REVIEW_CLOSE', false));
            if (isset($_POST['asg_id']) && isset($_POST['topic_id'])) 
            {
                do 
                {
                    if (!$data['submission_condition']["result"]) break;

                    $post_asg_id = decode_id($this->input->post('asg_id'));
                    $post_topic_id = decode_id($this->input->post('topic_id'));
                    $post_reviewer = decode_id($this->input->post('reviewer'));
                    $post_reviewee = decode_id($this->input->post('reviewee'));
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
                                    "question_id" => decode_id($qid),
                                    "reviewer" => $post_reviewer,
                                    "reviewee" => $post_reviewee,
                                    "feedback" => $feedback
                                );
                                echo decode_id($feedback_id).' ,';
                                if (!empty($feedback_id)) {
                                    $this->Assignment_feedback_model->update_assignment_feedback(decode_id($feedback_id), $params);
                                }
                                else {
                                    $this->Assignment_feedback_model->add_assignment_feedback($params);
                                }
                            }
                        }
                    }
                } while (0);
            }
            else{
                $data['asg_id'] = $asg_id;
                $data['topic_id'] = $topic_id;
                $data['username'] = $this->get_login_user();
                $data['assignment_questions_self'] = $this->Assignment_feedback_model->get_question_with_feedback($decode_asg_id,$this->get_login_user(),$this->get_login_user(),'SELF');
                $this->load->view('pages/assignment/self_feedback_form',$data);
            }
        } while(0);
    }

    function peer_feedback_form($asg_id = null , $topic_id = null) {
        do
        {
            if (!$this->check_permission(10) ) break;
            if (empty($topic_id)) break;
            $asg_result = $this->assignment_check($asg_id);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['assignment'] = $asg_result['asg_info'];

            $data['submission_condition'] = ($this->is_open($decode_asg_id,'PEER_REVIEW_OPEN','PEER_REVIEW_CLOSE', false));
            if (isset($_POST['asg_id']) && isset($_POST['topic_id'])) 
            {
                do {
                    if (!$data['submission_condition']["result"]) break;
                    $post_asg_id = decode_id($this->input->post('asg_id'));
                    $post_topic_id = decode_id($this->input->post('topic_id'));
                    $post_reviewer = decode_id($this->input->post('reviewer'));
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
                                        "question_id" => decode_id($qid),
                                        "reviewer" => $post_reviewer,
                                        "reviewee" => decode_id($reviewee),
                                        "feedback" => $feedback
                                    );
                                    if (!empty($feedback_id)) {
                                        $result = $this->Assignment_feedback_model->update_assignment_feedback(decode_id($feedback_id), $params);
                                    }
                                    else {
                                        $result = $this->Assignment_feedback_model->add_assignment_feedback($params);
                                    } 
                                }
                            }
                        }
                    }
                } while (0);
            }
            else
            {
                $data['asg_id'] = $asg_id;
                $data['topic_id'] = $topic_id;
                $data['username'] = $this->get_login_user();
                $data['assignment_topics_member'] = $this->Assignment_topic_model->get_assignment_member(decode_id($topic_id));
                foreach($data['assignment_topics_member'] as $member) {
                    $data['assignment_questions_peer'][$member['user_id']] = $this->Assignment_feedback_model->get_question_with_feedback($decode_asg_id,$this->get_login_user(),$member['user_id'],'PEER');
                }
                $this->load->view('pages/assignment/peer_feedback_form',$data);
            }
        } while(0);
    }

}
