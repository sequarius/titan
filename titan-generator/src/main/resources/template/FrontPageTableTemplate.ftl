import React from 'react';
import { Divider, Popconfirm, Tag, Button } from 'antd';
import ProTable from '@ant-design/pro-table';
import ${entityName}Modal from '../${entityName}Modal';
import { connect } from 'dva';
import {hasPermission} from '@/utils/authority';
import { Pagination } from 'antd';
import router from 'umi/router';

const ${entityName}Table = ({ dispatch, ${moduleName}${entityName}, loading }) => {
  const isLoading = loading.effects['${moduleName}${entityName}/list'];

  const columns = [
<#list fieldSpecs as fieldSpec>
    <#if (!fieldSpec.responseDTOIgnore??||!fieldSpec.responseDTOIgnore) && fieldSpec.name != 'deleted'>
    {
        title: '${fieldSpec.displayName}',
        dataIndex: '${fieldSpec.name}',
      <#if fieldSpec.type.simpleName=='Boolean'>
        render: (field, _) => (
          <>
            {field && <Tag color="success">√</Tag>}
            {!field && <Tag color="error">×</Tag>}
          </>
        )
      </#if>
    },
    </#if>
</#list>
    {
      title: '操作',
      dataIndex: 'option',
      render: (_, record) => (
        <span>
<#if !ignoreUpdateMethod?? || !ignoreUpdateMethod>
          {hasPermission('${moduleName}:${camelEntityName}:update')&&<a onClick={() => update${entityName}Handler(record)}>修改</a>}
</#if>
<#if !ignoreRemoveMethod?? || !ignoreRemoveMethod>
          {hasPermission('${moduleName}:${camelEntityName}:remove')&&<><Divider type="vertical" />
          <Popconfirm title="确认删除?" placement="leftTop" onConfirm={() => remove${entityName}Handler(record.id)}>
            <a>删除</a>
          </Popconfirm></>}
</#if>
        </span>
      ),
    },
  ];

  function remove${entityName}Handler(id) {
    dispatch({
      type: '${moduleName}${entityName}/remove${entityName}',
      payload: { id },
    });
  }

  function update${entityName}Handler(record) {
    dispatch({
      type: '${moduleName}${entityName}/set${entityName}',
      payload: { ${camelEntityName}: record },
    });
  }

  function pageChangedHandler(page) {
    router.push({
      pathname: '/${moduleName}/${camelEntityName}s',
      query: { page },
    });
  }

  return (
    <div>
      <div id="components-table-demo-basic">
        <ProTable
          options={{ density: true, fullScreen: true, setting: true }}
          rowKey="id"
          pagination={false}
          total={${moduleName}${entityName}.total}
<#if !ignoreSaveMethod?? || !ignoreSaveMethod>
          toolBarRender={(action, { selectedRows }) => [hasPermission("${moduleName}:${camelEntityName}:save")&&<${entityName}Modal />]}
</#if>
          headerTitle="${displayName}列表"
          search={false}
          columns={columns}
          loading={isLoading}
          dataSource={${moduleName}${entityName}.list}
        />
        <Pagination
          showSizeChanger = {false}
          showQuickJumper
          className="ant-table-pagination"
          onChange={pageChangedHandler}
          defaultCurrent={6}
          total={${moduleName}${entityName}.total}
          current={${moduleName}${entityName}.current}
        />
      </div>
    </div>
  );
};
export default connect(({ ${moduleName}${entityName}, loading }) => ({
  ${moduleName}${entityName},
  loading,
}))(${entityName}Table);
