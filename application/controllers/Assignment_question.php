<?php
 
class Assignment_question extends MY_PasController{
    function __construct()
    {
        parent::__construct();
        $this->load->model('assignment_question_model');
    } 

    function index($asg_id, $type = 'PEER')
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

            $type=strtoupper($type);
            $data['asg_id'] = $asg_id;
            $data['type'] = $type;
            $data['_view'] = 'pages/assignment_question/index';

            $data['assignment_questions'] = $this->assignment_question_model->get_assignment_question_by_asgid_section($asg_id,$type);
            $this->load->model('Assignment_model');
            $data['all_assignments'] = $this->Assignment_model->get_all_assignments();
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Assignmentadmin");
    }

    function add($asg_id, $type)
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

            $type=strtoupper($type);
            $data['asg_id'] = $asg_id;
            $data['type'] = $type;
            if (isset($_POST['counter'])) {
                $counter = $this->input->post('counter');
                for ($x = 0; $x <= intval($counter); $x++) {
                    if (isset($_POST['question'.$x])) {
                        $post_data = array (
                            "asg_id" => $this->input->post('asg_id'),
                            "question_order" => $this->input->post('question_order'.$x),
                            "question" => $this->input->post('question'.$x), 
                            "question_section" => $this->input->post('question_section'.$x), 
                            "answer_type" => $this->input->post('answer_type'.$x)
                        );
                        $this->assignment_question_model->add_assignment_question($post_data);
                    }
                }
                redirect('assignment_question/index/'.$asg_id);
            }
            $data['_view'] = 'pages/assignment_question/add';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Assignmentadmin");
    }  

    function edit($asg_id, $type, $id)
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
            $type=strtoupper($type);
            $data['asg_id'] = $asg_id;
            $data['type'] = $type;
            $data['assignment_question'] = $this->assignment_question_model->get_assignment_question($id);
            if(isset($data['assignment_question']['id']))
            {
                if (isset($_POST['question_order'])) {
                    $params = array(
                        "question_order" => $this->input->post('question_order'),
                        "question" => $this->input->post('question'), 
                        "question_section" => $this->input->post('question_section'), 
                        "answer_type" => $this->input->post('answer_type')
                    );

                    $this->assignment_question_model->update_assignment_question($id,$params);            
                    redirect('assignment_question/index/'.$asg_id);
                }

                $this->load->model('Assignment_model');
                $data['all_assignments'] = $this->Assignment_model->get_all_assignments();

                $data['_view'] = 'pages/assignment_question/edit';
                $this->load_header($data);
                $this->load->view('templates/main',$data);
                $this->load_footer($data);
                $done = true;
            }
        } while(0);

        if (!$done) redirect("Assignmentadmin");
    } 

    function remove($asg_id,$type,$id)
    {
        if ($this->check_permission(30)) {
            $type=strtoupper($type);
            $data['asg_id'] = $asg_id;
            $data['type'] = $type;
            $assignment_question = $this->assignment_question_model->get_assignment_question($id);

            if(isset($assignment_question['id']))
            {
                $this->assignment_question_model->delete_assignment_question($id);
                redirect('assignment_question/index/'.$asg_id);
            }
            else
                show_error('The assignment_question you are trying to delete does not exist.');
        }
    }
    
    function remove_all($asg_id, $type)
    {
        if ($this->check_permission(30)) {
            $type=strtoupper($type);
            $data['asg_id'] = $asg_id;
            $data['type'] = $type;
            
            $this->assignment_question_model->delete_assignment_question_all($asg_id, $type);
            redirect('assignment_question/index/'.$asg_id.'/'.$type);
        }
    }
    
    function copy_question() 
    {
        if ($this->check_permission(30)) {
            $from_id = $this->input->post('from_id') ;
            $to_id = $this->input->post('to_id') ;
            $question_section = $this->input->post('question_section') ;
            if ($from_id) {
                $this->assignment_question_model->copy_questions($from_id, $to_id);
            }
            redirect('assignment_question/index/'.$to_id.'/'.$question_section);
        }
    }
    
}
