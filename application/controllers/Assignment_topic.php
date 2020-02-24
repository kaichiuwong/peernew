<?php
 
class Assignment_topic extends MY_PasController{
    function __construct()
    {
        parent::__construct();
        $this->load->model('Assignment_topic_model');
    } 

    function index($asg_id)
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
            $data['_view'] = 'pages/assignment_topic/index';
            $data['assignment_topics'] = $this->Assignment_topic_model->get_assignment_topic_by_asgid($asg_id);
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Assignmentadmin");
    }

    function add($asg_id)
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

            if (isset($_POST['assign_id'])) {
                $this->Assignment_topic_model->bulk_add_assignment_topic(
                    $this->input->post('assign_id'), 
                    $this->input->post('group_num'), 
                    $this->input->post('max'),
                    $this->input->post('prefix')
                );
                redirect('assignment_topic/index/'.$asg_id);
            }

            $data['asg_id'] = $asg_id;
            $this->load->model('Assignment_model');
            $data['all_assignments'] = $this->Assignment_model->get_all_assignments();
            
            $data['_view'] = 'pages/assignment_topic/add';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Assignmentadmin");
    }  

    function edit($asg_id,$id)
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
            $data['assignment_topic'] = $this->Assignment_topic_model->get_assignment_topic($id);
            if(isset($data['assignment_topic']['id']))
            {
                if (isset($_POST['max'])) {
                    $params = array(
                        'topic' => $this->input->post('topic'),
                        'max' => $this->input->post('max'),
                        'topic_desc' => $this->input->post('topic_desc'),
                    );

                    $this->Assignment_topic_model->update_assignment_topic($id,$params);            
                    redirect('assignment_topic/index/'.$asg_id);
                }
                $this->load->model('Assignment_model');
                $data['all_assignments'] = $this->Assignment_model->get_all_assignments();

                $data['_view'] = 'pages/assignment_topic/edit';
                $this->load_header($data);
                $this->load->view('templates/main',$data);
                $this->load_footer($data);
                $done = true;
            }
        } while(0);

        if (!$done) redirect("Assignmentadmin");
    } 

    function remove($asg_id,$id)
    {
        if ($this->check_permission(30)) {
            $data['asg_id'] = $asg_id;
            $assignment_topic = $this->Assignment_topic_model->get_assignment_topic($id);

            if(isset($assignment_topic['id']))
            {
                $this->Assignment_topic_model->delete_assignment_topic($id);
                redirect('assignment_topic/index/'.$asg_id);
            }
            else
                show_error('The assignment_topic you are trying to delete does not exist.');
        }
    }
    
    function topic_member($id) 
    {
        if ($this->check_permission(20)) {
            $data['assignment_topics'] = $this->Assignment_topic_model->get_assignment_member($id);
            $this->load->view('pages/assignment_topic/topic_member',$data);
        }
    }
    
}
