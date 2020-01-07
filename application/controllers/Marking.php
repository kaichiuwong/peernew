<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Marking extends MY_PasController {
    function __construct()
    {
        parent::__construct();
        $this->load->model('Assignment_model');
        $this->load->model('Submission_model');
        $this->load->model('Assignment_mark_model');
        $this->load->model('Assignment_date_model');
        $this->load->model('Assignment_feedback_model'); 
        $this->load->model('Assignment_question_model'); 
        $this->load->model('Assignment_topic_model');
    } 

    function index() 
    {
        if (!$this->check_permission(20) )  break ;

        if ($this->check_permission(90, false)) 
        {
            $data['assignments'] = $this->Assignment_model->get_all_assignments();
        }
        else 
        {
            $data['assignments'] = $this->Assignment_model->get_all_assignments($this->get_login_user());
        }
        $data['_view'] = 'pages/assignment_marking/index';
        $this->load_header($data);
        $this->load->view('templates/main',$data);
        $this->load_footer($data);
    }

    function group($asg_id = null)
    {
        $done = false;
        do 
        {
            if (!$this->check_permission(20) )  break ;
            $asg_result = $this->assignment_check($asg_id);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['assignment'] = $asg_result['asg_info'];
            $data['asg_header'] = $asg_result['asg_header'];
            $data['asg_id'] = $asg_id;

            $data['assignment_topics'] = $this->Submission_model->get_group_submission($decode_asg_id);
            $data['asg_deadline'] = $this->Assignment_date_model->get_date_by_asg_id_key($decode_asg_id, 'SUBMISSION_DEADLINE');
            $data['_view'] = 'pages/assignment_marking/group_submission';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Marking");
    }

    function peer($asg_id = null)
    {
        $done = false;
        do 
        {
            if (!$this->check_permission(20) )  break ;
            $asg_result = $this->assignment_check($asg_id);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['assignment'] = $asg_result['asg_info'];
            $data['asg_header'] = $asg_result['asg_header'];
            $data['asg_id'] = $asg_id;

            $data['students'] = $this->Submission_model->get_peer_review_summary($decode_asg_id);
            $data['_view'] = 'pages/assignment_marking/peer_submission';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Marking");
    }


    function final_score($asg_id = null)
    {
        $done = false;
        do 
        {
            if (!$this->check_permission(20) )  break ;
            $asg_result = $this->assignment_check($asg_id);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['assignment'] = $asg_result['asg_info'];
            $data['asg_header'] = $asg_result['asg_header'];
            $data['asg_id'] = $asg_id;

            $data['students'] = $this->Submission_model->get_final_score($decode_asg_id);
            $data['_view'] = 'pages/assignment_marking/final_score';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Marking");
    }

    function give_indiv_feedback($asg_id = null, $group_id = null, $username = null)
    {
        $done = false;
        do 
        {
            if (!$this->check_permission(20) )  break ;
            if (empty($asg_id) || empty($group_id) || empty($username)) break;
            $asg_result = $this->assignment_check($asg_id);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['asg_id'] = $asg_id;
            $data['group_id'] = $group_id;
            $data['username'] = $username;
            $data['summary'] = $this->Submission_model->get_peer_review_summary($decode_asg_id,$username);
            $data['_view'] = 'pages/assignment_marking/indiv_feedback';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
        } while (0);

        if (!$done) redirect("Marking");
    }

    function give_group_feedback($asg_id = null, $group_id = null)
    {
        $done = false;
        do 
        {
            if (!$this->check_permission(20) )  break ;
            if (empty($asg_id) || empty($group_id)) break;
            $asg_result = $this->assignment_check($asg_id);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['asg_id'] = $asg_id;
            $data['group_id'] = $group_id;
            $data['summary'] = $this->Submission_model->get_group_submission($decode_asg_id);
            $data['_view'] = 'pages/assignment_marking/group_feedback';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
        } while(0);

        if (!$done) redirect("Marking");
    }

    function export_score($asg_id = null)
    {
        do 
        {
            if (!$this->check_permission(20, false) ) break;
            if (empty($asg_id)) break;
            $asg_result = $this->assignment_check($asg_id);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];

            $this->load->library('excel');
            $objPHPExcel = new PHPExcel();
            $objPHPExcel->setActiveSheetIndex(0);
            $objPHPExcel->getActiveSheet()->SetCellValue('A1', 'Unit');
            $objPHPExcel->getActiveSheet()->SetCellValue('B1', 'Student ID');
            $objPHPExcel->getActiveSheet()->SetCellValue('C1', 'Username');
            $objPHPExcel->getActiveSheet()->SetCellValue('D1', 'Student Name');
            $objPHPExcel->getActiveSheet()->SetCellValue('E1', 'Group');
            $objPHPExcel->getActiveSheet()->SetCellValue('F1', 'Group Score');       
            $objPHPExcel->getActiveSheet()->SetCellValue('G1', 'Peer Score');       
            $objPHPExcel->getActiveSheet()->SetCellValue('H1', 'Total Score');       
            $rowCount = 2;
            $score_list = $this->Submission_model->get_final_score($decode_asg_id);
            $unit_code='';
            foreach ($score_list as $list) {
                $unit_code=$list['unit_code'];
                $objPHPExcel->getActiveSheet()->SetCellValue('A' . $rowCount, $list['unit_code']);
                $objPHPExcel->getActiveSheet()->SetCellValue('B' . $rowCount, $list['sid']);
                $objPHPExcel->getActiveSheet()->SetCellValue('C' . $rowCount, $list['username']);
                $objPHPExcel->getActiveSheet()->SetCellValue('D' . $rowCount, $list['first_name']. ' ' . $list['last_name']);
                $objPHPExcel->getActiveSheet()->SetCellValue('E' . $rowCount, $list['topic']);
                $objPHPExcel->getActiveSheet()->SetCellValue('F' . $rowCount, $list['group_score']?sprintf("%.2f", $list['group_score']):0);
                $objPHPExcel->getActiveSheet()->SetCellValue('G' . $rowCount, $list['peer_score']?sprintf("%.2f", $list['peer_score']):0);
                $objPHPExcel->getActiveSheet()->SetCellValue('H' . $rowCount, $list['total_score']?sprintf("%.2f", $list['total_score']):0);
                $rowCount++;
            }
            $filename = "final_score_". $asg_id . "_" .date("Ymd_His").".xlsx";
            $objWriter = new PHPExcel_Writer_Excel2007($objPHPExcel);
            $objWriter->save('./export/'.$filename);
            // download file
            header("Content-Type: application/vnd.ms-excel");
            redirect(base_url()."/export/".$filename); 
        } while (0);
    }

    function peer_detail($asg_id = null, $group_id = null, $username = null)
    {
        do 
        {
            if (!$this->check_permission(20, false) ) break;
            if (empty($asg_id) || empty($group_id) || empty($username)) break;
            $asg_result = $this->assignment_check($asg_id);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['asg_id'] = $asg_id;
            $data['group_id'] = $group_id;
            $data['username'] = $username;

            $data['summary'] = $this->Submission_model->get_peer_review_summary($decode_asg_id,decode_id($username));
            $data['assignment_questions_self'] = $this->Assignment_feedback_model->get_question_with_feedback($decode_asg_id,decode_id($username),decode_id($username),'SELF');
            $data['assignment_topics_member'] = $this->Assignment_topic_model->get_assignment_member(decode_id($group_id));
            foreach($data['assignment_topics_member'] as $member) {
                $data['assignment_questions_peer'][$member['user_id']] = $this->Assignment_feedback_model->get_question_with_feedback($decode_asg_id,$member['user_id'],decode_id($username),'PEER');
            }
            $this->load->view('pages/assignment_marking/peer_detail',$data);
        } while(0);
    }

    function save_group_submission()
    {
        header('Content-Type: application/json');
        $done = false;
        $http_code = 500;
        $score_id = null;

        do {
            if (!$this->check_permission(20, false) ) break;
            if (!isset($_POST['asg_id'])) break;
            if (!isset($_POST['topic_id'])) break;

            $params = array(
                'asg_id' => decode_id($this->input->post('asg_id')),
                'group_id' => decode_id($this->input->post('topic_id'))
            );
            if (isset($_POST['score'])) {
                $params['score'] = $this->input->post('score');
            }
            if (isset($_POST['remark'])) {
                $params['remark'] = $this->input->post('remark');
            }
            if (isset($_POST['score_id'])) {
                if ( !empty($_POST['score_id']) ) {
                    $score_id = $this->input->post('score_id');
                }
            }
            $current_user = $this->get_login_user();
            empty($score_id)? 
                ( $score_id = encode_id($this->Assignment_mark_model->create_group_mark($current_user, $params)) ) :
                ( $this->Assignment_mark_model->update_group_mark(decode_id($score_id), $current_user, $params) ) ;
            $done = true;
            $http_code = 200;
        } while(0);

        return $this->output
            ->set_content_type('application/json')
            ->set_status_header($http_code)
            ->set_output( json_encode( array('score_id' => $score_id, 'status' => $done) ) );
    }

    function override_peer_mark()
    {
        header('Content-Type: application/json');
        $done = false;
        $http_code = 500;
        $score_id = null;
        do {
            if (!$this->check_permission(20, false) ) break;
            if (!isset($_POST['asg_id'])) break;
            if (!isset($_POST['username'])) break;
            $params = array(
                'asg_id' => decode_id($this->input->post('asg_id')),
                'username' => decode_id($this->input->post('username'))
            );
            if (isset($_POST['score'])) $params['score'] = $this->input->post('score');
            if (isset($_POST['remark'])) $params['remark'] = $this->input->post('remark');
            if (isset($_POST['score_id'])) {
                if ( !empty($_POST['score_id']) ) {
                    $score_id = $this->input->post('score_id');
                }
            }
            $current_user = $this->get_login_user();
            empty($score_id)? 
                ( $score_id = encode_id($this->Assignment_mark_model->create_peer_mark($current_user, $params)) ) :
                ( $this->Assignment_mark_model->update_peer_mark(decode_id($score_id), $current_user, $params) ) ;
            $done = true;
            $http_code = 200;
        } while(0);

        return $this->output
            ->set_content_type('application/json')
            ->set_status_header($http_code)
            ->set_output( json_encode( array('score_id' => $score_id, 'status' => $done) ) );
    }

}
