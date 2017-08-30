<%@ page contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html manifest="${env['app_manifest']}" >
<head>
	<meta charset="UTF-8">
    <title>系统参数管理</title>
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
    
 	<div id="mainWindow" class="easyui-layout" data-options="fit:true" style="display:none">
    	<!-- 查询条件  -->
		<div data-options="region:'north', title:'角色表-条件'"
			style="height: 80px; padding: 5px 20px;">
			<form id="search-form" >
				<table class="search-table">
					<tr>
						<td>
							 参数配置类型
							<input class="easyui-combobox" class="input_query" name="confType" id="query_confType"
								 style="width:100px" data-options="
								valueField: 'id',
								textField: 'name',
								data: getDictData(dict_tf_conf_type,'all'),onChange:onChangeConfType,formatter:formatterConfType" readOnly/>
						</td>
						<td>
							名称:
							<input type="text" class="input_query" name="name" id="query_name"/>
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
	    	<div id="toolbar">
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="onAdd()">New</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="onEdit()">Edit</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="onDestroy()">Remove</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="onExpandAll()">Expand all</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="onCollapseAll()">Collapse all</a>
		    </div>
		    <div class="easyui-panel" style="padding:5px" width="100%">
				<ul id="menuTree" class="easyui-tree" data-options="url:'/basedata/sysconfig/findSysconfigByParentId?confType=4'
					,animate:true,lines:true,formatter:formatter
					,onDblClick:onDblClick,onClick:onClick
					,onAfterEdit:onAfterEdit,onBeforeExpand:onBeforeExpand,onLoadSuccess:onLoadSuccess
					,onContextMenu: function(e,node){
						e.preventDefault();
						$(this).tree('select',node.target);
						$('#mm').menu('show',{
							left: e.pageX,
							top: e.pageY
						});
					}"></ul>
			</div>
		 </div>
	</div>
	
	<div id="mm" class="easyui-menu" style="width:120px;">
		<div onclick="append()" data-options="iconCls:'icon-add'">Append</div>
		<div onclick="editit()" data-options="iconCls:'icon-edit'">Edit</div>
		<div onclick="removeit()" data-options="iconCls:'icon-remove'">Remove</div>
		<div class="menu-sep"></div>
		<div onclick="expand()">Expand</div>
		<div onclick="collapse()">Collapse</div>
	</div>
    
    <div id="dlg" class="easyui-dialog" style="width:510px;height:400px;padding:10px 20px;display:none"
            closed="true" buttons="#dlg-buttons">
        <fieldset>
			<legend>
				系统参数管理
			</legend>   
	        <form id="fm" method="post" novalidate>
	        	<input type="hidden" name="cid">
	        	<input type="hidden" name="pid">
	        	<input type="hidden" name="name">
	        	<input type="hidden" name="code">
	        	<input type="hidden" name="sysconfigId" id="sysconfig_sysconfigId">
	        	<input type="hidden" name="confType" id="sysconfig_confType">
	        	<div class="fitem">
	                <label>Parent:</label>
	                <label><div id="parentName" style="width:300px"></div></label>
	            </div>
	            <div class="fitem">
	                <label>编码:</label>
	                <label><div id="v_code" name="code" style="width:300px"></div></label>           
	            </div>
	            <div class="fitem">
	                <label>名称:</label>
	                <label><div id="v_name" name="name" style="width:300px"></div></label>
	            </div>
	            <div class="fitem">
	                <label>值:</label>
	                <textarea name="value" id="sysconfig_value" style="height:60px;width:280px" required="true"></textarea>
	            </div>
	            <div class="fitem">
	                <label>默认值:</label>
	                <textarea name="valueDefault" id="sysconfig_valueDefault" style="height:60px;width:280px" required="true"></textarea>
	            </div>
	            <div class="fitem">
	                <label>json值:</label>
	                <textarea name="valueJson" id="sysconfig_valueJson" style="height:60px;width:280px"></textarea>
	            </div>
	            <%/* 
	            <div class="fitem">
	                <label>顺序号:</label>
	                <input name="orderCount" class="easyui-validatebox" required="true">
	            </div>
	            <div class="fitem">
	                <label>是否环境参数:</label>
	                <input class="easyui-combobox" name="ifEnv" id="sysconfig_ifEnv" required="true" data-options="
									valueField: 'id',
									textField: 'name',
									//multiple:true, //多选增加此项
									data: dict_tf_if" />
	            </div>
	            <div class="fitem">
	                <label>状态:</label>
	                <input class="easyui-combobox" name="status" required="true" data-options="
									valueField: 'id',
									textField: 'name',
									//multiple:true, //多选增加此项
									data: dict_tf_status" />
	            </div>
	            <div class="fitem">
	                <label>是否可修改:</label>
	                <input class="easyui-combobox" name="canModify" id="sysconfig_canModify" required="true" data-options="
									valueField: 'id',
									textField: 'name',
									//multiple:true, //多选增加此项
									data: dict_tf_if" />
	            </div>
	            */ %>
	            <div class="fitem">
	                <label>备注:</label>
	                <textarea name="remark" id="lookupItem_remark" style="height:60px;width:220px"></textarea>
	            </div>
	       </form>
	     </fieldset>
	     <div id="dlg-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="onSave()">Save</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">Cancel</a>
	    </div>
	 </div>
    
  
    <script type="text/javascript" src="/scripts/basedata/sysconfigTree.js"></script>
    <script type="text/javascript" src="/scripts/basedata/sysconfigUserTree.js"></script>
    <script type="text/javascript">
    function onLoadSuccess(){
    	openRoot();
    }
    $(function () {
    	 $('#query_confType').combobox('select', '4');
		setTimeout("openRoot()", 200);
	});
    </script>
    
    <%@ include file="/system/_foot.jsp"%>
</body>
</html>