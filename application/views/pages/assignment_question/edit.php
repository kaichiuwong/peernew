<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $this->session->userdata('asg_header'); ?></h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignmentadmin'); ?>">Assignment List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignmentadmin/edit/'.$asg_id); ?>">Edit Info</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_topic/index/'.$asg_id); ?>">Group List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('student_list/index/'.$asg_id); ?>">Student List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/self'; ?>">Self Evaluation</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/peer'; ?>">Peer Review</a></li>
          <li class="breadcrumb-item active">Edit Questions</li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="card card-secondary">
    <div class="card-header">
        <h3 class="card-title">Edit Question</h3>
    </div>
    <?php echo form_open('assignment_question/edit/'.$asg_id.'/'.$type.'/'.$assignment_question['id'],array("class"=>"form-horizontal")); ?>
    <div class="card-body table-responsive-sm p-3">
        <input type="hidden" name="asg_id" value="<?php echo $asg_id; ?>" required />
        <table id="myTable" class="table table-head-fixed table-hover order-list">
            <thead>
                <tr>
                    <th style="width: 10%">Order</th>
                    <th style="width: 50%">Question</th>
                    <th style="width: 20%">Question Section</th>
                    <th style="width: 20%">Answer Type</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <tr id="first_row">
                    <td>
                        <input type="number" min="1" step="1" value="<?php echo $assignment_question['question_order']; ?>" name="question_order" class="form-control" />
                    </td>
                    <td>
                        <input type="hidden" name="asg_id" value="<?php echo $assignment_question['asg_id']; ?>" required />
                        <input type="text" name="question" class="form-control" value="<?php echo ($this->input->post('question') ? $this->input->post('question') : $assignment_question['question']); ?>" />
                    </td>
                    <td>
                        <select class="form-control" name="question_section" >
                            <option value="SELF" <?php echo $assignment_question['question_section'] == "SELF"?"selected":"";?> >Self Evaluation Only (Private)</option>
                            <option value="PEER" <?php echo $assignment_question['question_section'] == "PEER"?"selected":"";?> >Peer Evaluation (Viewable by Peers)</option>
                        </select>
                    </td>
                    <td>
                        <select class="form-control" name="answer_type" >
                            <option value="TEXT" <?php echo $assignment_question['answer_type'] == "TEXT"?"selected":"";?> >Text</option>
                            <option value="SCALE" <?php echo $assignment_question['answer_type'] == "SCALE"?"selected":"";?> >Scale (0-4)</option>
                            <option value="SCORE" <?php echo $assignment_question['answer_type'] == "SCORE"?"selected":"";?> >Score (0%-100%)</option>
                            <option value="GRADE" <?php echo $assignment_question['answer_type'] == "GRADE"?"selected":"";?> >Grade (NN/PP/CR/DN/HD)</option>
                        </select>
                    </td>
                    <td class="col-sm-2">
                        <a class="deleteRow"></a>
                    </td>
                </tr>
            </tbody>
            <tfoot>

            </tfoot>
        </table>
    </div>
    <div class="card-footer">
        <button type="submit" class="btn btn-primary">Save</button>
    </div>
    <?php echo form_close(); ?>
</div>