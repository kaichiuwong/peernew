<?php
 
class Assignment_topic extends MY_PasController{
    function __construct()
    {
        parent::__construct();
        $this->load->model('Assignment_topic_model');
    } 

    function index($asg_id)
    {
        if ($asg_id) {
            $data['asg_id'] = $asg_id;
            if ($this->check_permission(20)) {
                $data['_view'] = 'pages/assignment_topic/index';
                $data['assignment_topics'] = $this->Assignment_topic_model->get_assignment_topic_by_asgid($asg_id);
                $this->load_header($data);
                $this->load->view('templates/main',$data);
                $this->load_footer($data);
            }
        }
        else {
            redirect('assignmentadmin');
        }
    }

    function add($asg_id)
    {   
        if ($this->check_permission(20)) {
            $data['asg_id'] = $asg_id;
            $this->load->library('form_validation');
            
            $this->form_validation->set_rules('assign_id','Assignment ID','required');
            $this->form_validation->set_rules('group_num','Number of Group','required');
            $this->form_validation->set_rules('max','Max number per group','required');
            
            if($this->form_validation->run())     
            {   
                $this->Assignment_topic_model->bulk_add_assignment_topic(
                        $this->input->post('assign_id'), 
                        $this->input->post('group_num'), 
                        $this->input->post('max'),
                        $this->input->post('prefix')
                );
                redirect('assignment_topic/index/'.$asg_id);
            }
            else
            {
                $this->load->model('Assignment_model');
                $data['all_assignments'] = $this->Assignment_model->get_all_assignments();
                
                $data['_view'] = 'pages/assignment_topic/add';
                $this->load_header($data);
                $this->load->view('templates/main',$data);
                $this->load_footer($data);
            }
        }
    }  

    function edit($asg_id,$id)
    {   
        if ($this->check_permission(20)) {
            $data['asg_id'] = $asg_id;
            $data['assignment_topic'] = $this->Assignment_topic_model->get_assignment_topic($id);
            
            if(isset($data['assignment_topic']['id']))
            {
                $this->load->library('form_validation');

                $this->form_validation->set_rules('max','Max number per group','required');
            
                if($this->form_validation->run())     
                {   
                    $params = array(
                        'topic' => $this->input->post('topic'),
                        'max' => $this->input->post('max'),
                        'topic_desc' => $this->input->post('topic_desc'),
                    );

                    $this->Assignment_topic_model->update_assignment_topic($id,$params);            
                    redirect('assignment_topic/index/'.$asg_id);
                }
                else
                {
                    $this->load->model('Assignment_model');
                    $data['all_assignments'] = $this->Assignment_model->get_all_assignments();

                    $data['_view'] = 'pages/assignment_topic/edit';
                    $this->load_header($data);
                    $this->load->view('templates/main',$data);
                    $this->load_footer($data);
                }
            }
            else
                show_error('The assignment_topic you are trying to edit does not exist.');
        }
    } 

    function remove($asg_id,$id)
    {
        if ($this->check_permission(20)) {
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
