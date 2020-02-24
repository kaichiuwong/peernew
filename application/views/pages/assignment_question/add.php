<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $asg_header; ?></h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('Assignmentadmin'); ?>">Assignment List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Assignmentadmin/info/'.$asg_id); ?>">Info</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_date/index/'.$asg_id); ?>">Timeline</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_topic/index/'.$asg_id); ?>">Group List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('student_list/index/'.$asg_id); ?>">Student List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Staff_list/index/'.$asg_id); ?>">Staff List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/self'; ?>">Self Evaluation</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/peer'; ?>">Peer Review</a></li>
          <li class="breadcrumb-item active">Create Questions</li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="card card-secondary">
    <div class="card-header">
        <h3 class="card-title">Create Questions</h3>
    </div>
    <?php echo form_open('assignment_question/add/'.$asg_id.'/'.$type,array("class"=>"form-horizontal")); ?>
    <div class="card-body table-responsive-sm p-3">
        <input type="hidden" name="asg_id" value="<?php echo $asg_id; ?>" required />
        <input type="hidden" name="counter" value="0" id="counter" required />
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
                        <input type="number" min="1" step="1" value="1" name="question_order0" class="form-control" />
                    </td>
                    <td>
                        <input type="text" name="question0" class="form-control" />
                    </td>
                    <td>
                        <select class="form-control" name="question_section0" >
                            <option value="SELF">Self Evaluation Only (Private)</option>
                            <option value="PEER">Peer Evaluation (Viewable by Peers)</option>
                        </select>
                    </td>
                    <td>
                        <select class="form-control" name="answer_type0" >
                            <option value="TEXT">Text</option>
                            <option value="SCALE">Scale (0-4)</option>
                            <option value="SCORE">Score (0%-100%)</option>
                            <option value="GRADE">Grade (NN/PP/CR/DN/HD)</option>
                        </select>
                    </td>
                    <td class="col-sm-2">
                        <a class="deleteRow"></a>
                    </td>
                </tr>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="5" style="text-align: left;">
                        <input type="button" class="btn btn-sm btn-block btn-primary" id="addrow" value="Add Question" />
                    </td>
                </tr>
                <tr>
                </tr>
            </tfoot>
        </table>
    </div>
    <div class="card-footer">
        <button type="submit" class="btn btn-primary btn-sm">Create</button>
        <a href="<?php echo site_url('assignment_question/index/'.$asg_id.'/peer'); ?>" class="btn btn-sm btn-secondary">Cancel</a>
    </div>
    <?php echo form_close(); ?>
</div>