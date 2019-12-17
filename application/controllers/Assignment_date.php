<?php
 
class Assignment_date extends MY_PasController{
    function __construct()
    {
        parent::__construct();
        $this->load->model('Assignment_date_model');
    } 

    function index($asg_id)
    {
        if ($asg_id) {
            $data['asg_id'] = $asg_id;
            if ($this->check_permission(20)) {
                $data['_view'] = 'pages/Assignment_date/index';
                $data['Assignment_dates'] = $this->Assignment_date_model->get_all_dates_by_asg_id($asg_id);
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
                $this->Assignment_date_model->bulk_add_Assignment_date(
                        $this->input->post('assign_id'), 
                        $this->input->post('group_num'), 
                        $this->input->post('max'),
                        $this->input->post('prefix')
                );
                redirect('Assignment_date/index/'.$asg_id);
            }
            else
            {
                $this->load->model('Assignment_model');
                $data['all_assignments'] = $this->Assignment_model->get_all_assignments();
                
                $data['_view'] = 'pages/Assignment_date/add';
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

            $data['Assignment_date'] = $this->Assignment_date_model->get_Assignment_date($id);
            
            if(isset($data['Assignment_date']['id']))
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

                    $this->Assignment_date_model->update_Assignment_date($id,$params);            
                    redirect('Assignment_date/index/'.$asg_id);
                }
                else
                {
                    $this->load->model('Assignment_model');
                    $data['all_assignments'] = $this->Assignment_model->get_all_assignments();

                    $data['_view'] = 'pages/Assignment_date/edit';
                    $this->load_header($data);
                    $this->load->view('templates/main',$data);
                    $this->load_footer($data);
                }
            }
            else
                show_error('The Assignment_date you are trying to edit does not exist.');
        }
    } 

    function remove($asg_id,$id)
    {
        if ($this->check_permission(20)) {
            $data['asg_id'] = $asg_id;
            $Assignment_date = $this->Assignment_date_model->get_Assignment_date($id);

            // check if the Assignment_date exists before trying to delete it
            if(isset($Assignment_date['id']))
            {
                $this->Assignment_date_model->delete_Assignment_date($id);
                redirect('Assignment_date/index/'.$asg_id);
            }
            else
                show_error('The Assignment_date you are trying to delete does not exist.');
        }
    }
    
    function json($asg_id) 
    {
        $output_array = array();
        if ($this->check_permission(20)) {
            $asg_dates = $this->Assignment_date_model->get_all_dates_by_asg_id($asg_id);
            foreach($asg_dates as $d) {
                $element = array (
                    "title" => $d['description'],
                    "start" => $d['date_value'],
                    "end" => $d['date_value'],
                    "slotDuration" =>'00:01' ,
                    "backgroundColor" => '#5bc0de',
                    "url" => ''
                );
                $output_array[] = $element ; 
            }
        }
        echo json_encode($output_array);
    }
    
}
