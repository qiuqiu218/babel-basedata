<%@ page contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <title></title>
    <%@ include file="/system/_script.jsp"%>
	
	<style type="text/css">
      #fm{
          margin:0;
          padding:10px 20px;
      }
      .ftitle{
          font-size:14px;
          font-weight:bold;
          padding:5px 0;
          margin-bottom:10px;
          border-bottom:1px solid #ccc;
      }
      .fitem{
          margin-bottom:5px;
      }
      .fitem label{
          display:inline-block;
          width:60px;
      }
      .input_query{
      	width: 80px;
      }
      input,textarea {
	width: 160px;
	border: 1px solid #ccc;
	padding: 2px;
}
</style>
</head>

<body>
    
 	<div class="easyui-layout" data-options="fit:true">
    	<!-- 查询条件  -->
		<div data-options="region:'north', title:'黑白名单管理（如果有白名单，先于黑名单)-条件'"
			style="height: 80px; padding: 5px 80px;display:none;">
			<form id="search-form" >
				<input type="hidden" name="whiteTypeId" id="query_whiteTypeId">
				<table class="search-table">
					<tr>
						<td>
							白名单内容:
							<input type="text" class="input_query" name="content" id="query_content"/>
						</td>
						<td>
							状态:
							<input class="easyui-combobox" class="input_query" name="status" id="query_status" data-options="
								valueField: 'id',
								textField: 'name',
								data: getDictData(dict_tf_status,'all')" style="width:100px"/>
						</td>
						<td>
							<a class="easyui-linkbutton"
								data-options="iconCls:'icon-search'" id="search-btn">查询</a>
							<a class="easyui-linkbutton"
								data-options="iconCls:'icon-reload'" id="reset-btn">重置</a>
						</td>

					</tr>
				</table>
			</form>
		</div>
		
		<!-- 查询结果 center -->
	    <div data-options="region:'center', title:'查询结果'">
	    	<div id="toolbar" style="display:none;">
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="onAdd()">新增</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="onEdit()">修改</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="onDestroy()">删除</a>
		    </div>
		    <table id="dg" class="easyui-datagrid" data-options="onDblClickRow:onDblClick, onClickRow:onClick, onLoadSuccess:function(){$('.datagrid-btable').find('div.datagrid-cell').css('text-align','left');}"
		            url="/basedata/whiteList/list"
		            toolbar="#toolbar" pagination="true"
		            rownumbers="true" fitColumns="true" singleSelect="true" style="display:none;">
		        <thead>
		            <tr >
		            	<%/* 
		            	<th align="center" field="cid" width="50" sortable="true">编号</th>
		            	<th align="center" field="whiteTypeId" width="50" sortable="true">白名单类型</th>
		            	*/ %>
						
						<th align="center" field="content" width="50" sortable="true">白名单内容</th>
						<th align="center" field="status" width="10" sortable="true" formatter="renderStatus">状态</th>
						 <%/* */ %>
		                <th align="center" field="create_disp" width="100" sortable="true"  hidden="true">Create user</th>
		                <th align="center" field="createDate"  width="120"  sortable="true"  hidden="true">Create date</th>
		                <th align="center" field="modify_disp" width="100" sortable="true"  hidden="true">Modify user</th>
		                <th align="center" field="modifyDate"   width="120" sortable="true"  hidden="true">Modify date</th>
		               
		                <th align="center" field="remark" width="150"  hidden="true"> 备注</th>
		               
		            </tr>
		        </thead>
		    </table>
		 </div>
	</div>
    
    <div id="dlg" class="easyui-dialog" style="width:400px;height:300px;padding:5px 10px;display:none;"
            closed="true" buttons="#dlg-buttons">
        <fieldset>
			<legend>
				
			</legend>   
	        <form id="fm" method="post" novalidate>
	        	<input type="hidden" name="cid">
	        	<input type="hidden" name="whiteTypeId" id="whiteList_whiteTypeId">
	        	<%/* 
				<div class="fitem">
	                <label>白名单类型</label>
	                <input name="whiteTypeId" class="easyui-validatebox" required="true">
	            </div>
	            */ %>
				<div class="fitem">
	                <label>白名单内容</label>
	                <textarea name="content" id="whiteList_content" required="true" style="height:60px;width:200px"></textarea>
	            </div>
	            <div class="fitem">
	                <label>状态:</label>
	                <input class="easyui-combobox" name="status" id="whiteList_status" required="true" data-options="panelHeight:'auto',
									valueField: 'id',
									textField: 'name',
									//multiple:true, //多选增加此项
									data: dict_tf_status" />
	            </div>
				<div class="fitem">
	                <label>备注:</label>
	                <textarea name="remark" id="whiteList_remark" style="height:60px;width:200px"></textarea>
	            </div>	
	            <%/*
	            
	            <div class="fitem">
	                <label>备注:</label>
	                <textarea name="remark" id="whiteList_remark" style="height:60px;width:200px"></textarea>
	            </div>
	            */ %>
	        </form>
        </fieldset>
        <div id="dlg-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="onSave()">Save</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">Cancel</a>
	    </div>
    </div>
    
    <script type="text/javascript">
	    var whiteTypeId;
		function getLookupIdByParent(){
			var lkId=parent.parent_data.whiteTypeId;
			if(whiteTypeId!=lkId){
				whiteTypeId=lkId;
				
				console.log('----whiteTypeId='+whiteTypeId);
				$('#query_whiteTypeId').val(whiteTypeId);
				doSearch();
			}
		}
		if(parent){
			setInterval("getLookupIdByParent()",200);
		}
	    $('#search-btn').click(function(){
	    	doSearch();
		});
		$('#reset-btn').click(function(){
			$('#search-form')[0].reset();
		});
		
		function doSearch(){
        	var jsonParam = $('#search-form').serializeJson();
			$('#dg').datagrid('load', jsonParam);
        }
		
		
		
		function doSearchReload(){
        	var jsonParam = $('#search-form').serializeJson();
			$('#dg').datagrid('reload', jsonParam);
        }
		
		function onDblClick(rowIndex, rowData){
        	//alert('---onDblClick--rowIndex='+rowIndex+' row.cid='+rowData.cid);
        	onEdit();
        }
		
		function onClick(rowIndex, rowData){
        	
        }
		
		function listenerName(ex) {
	        if (ex.keyCode == 13) {                
	        	doSearch();
	        }
	    }
		$('#query_code').keydown(listenerName);
		$('#query_name').keydown(listenerName);
	
        var url;
        function onAdd(){
            $('#dlg').dialog('open').dialog('setTitle','New WhiteList');
            $('#fm').form('clear');
            $('#whiteList_status').combobox('select', '1');

            if(parent){
             	var whiteTypeId=   parent.parent_data.whiteTypeId;
             	console.log('--------whiteTypeId='+whiteTypeId);
             	$("#whiteList_whiteTypeId").val(whiteTypeId);
            }
            //$("#whiteList_remark").val('test');
        }
        
        function getRowData(entityName, row){
        	var tmp;
        	var obj={}
        	obj[entityName]={};
        	for(i in row){
        		tmp = row[i];
        		obj[i]=tmp;
        	}
        	return obj;
        }
        function onEdit(){
            var row = $('#dg').datagrid('getSelected');
            if (row){
            	var entityName='whiteList';
            	var obj = getRowData(entityName, row);
                $('#dlg').dialog('open').dialog('setTitle','Edit WhiteList');
                $('#fm').form('clear');
                $('#fm').form('load',obj);
            }
           
        }
        function onSave(){
        	var row = $('#dg').datagrid('getSelected');
            if (row){
            	if(row.canModify==0){
            		$.messager.show({
                        title: 'Error',
                        msg: '不可修改，禁止操作'
                    });
            		return;
            	}
            }
            $('#fm').form('submit',{
                url: '/basedata/whiteList/save',
                onSubmit: function(){
                    return $(this).form('validate');
                },
                success: function(result){
                    var result = eval('('+result+')');
                    if (!result.success){
                        $.messager.show({
                            title: result.msgCode,
                            msg: result.msgBody
                        });
                    } else {
                        $('#dlg').dialog('close');        // close the dialog
                        $.messager.show({
                            title: result.msgCode,
                            msg: result.msgBody
                        });
                        doSearchReload();    // reload the user data
                    }
                }
            });
        }
        function onDestroy(){
            var row = $('#dg').datagrid('getSelected');
            if (row){
                $.messager.confirm('Confirm','Are you sure you want to destroy this data?',function(r){
                    if (r){
                        $.post('/basedata/whiteList/delete',{id:row.cid},function(result){
                            if (result.success){
                            	doSearchReload();    // reload the user data
                            } else {
                                $.messager.show({    // show error message
                                    title: 'Error',
                                    msg: result.msgBody
                                });
                            }
                        },'json');
                    }
                });
            }
        }
    </script>
    <%@ include file="/system/_foot.jsp"%>
</body>
</html>