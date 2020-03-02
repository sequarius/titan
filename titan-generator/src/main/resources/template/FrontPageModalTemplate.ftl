import React, { useEffect } from 'react';
import { Modal, Button, Form, Input, InputNumber, Switch, DatePicker} from 'antd';

import { connect } from 'dva';
import moment from 'moment';

const layout = {
    labelCol: { span: 8 },
    wrapperCol: { span: 16 },
};

const ${entityName}Modal = ({ dispatch, ${moduleName}${entityName}, loading }) => {
    const [form] = Form.useForm();

    const updateLoading = loading.effects['${moduleName}${entityName}/update${entityName}'];
    const saveLoading = loading.effects['${moduleName}${entityName}/save${entityName}'];

    function show${entityName}Modal() {
        dispatch({
            type: '${moduleName}${entityName}/set${entityName}',
            payload: { ${camelEntityName}: {} },
        });
    }

    useEffect(() => {
        if (${moduleName}${entityName}.${camelEntityName} !== null) {
            form.resetFields();
            let ${camelEntityName}  = { ...${moduleName}${entityName}.${camelEntityName},<#list fieldSpecs as fieldSpec><#if (!fieldSpec.requestDTOIgnore??||!fieldSpec.requestDTOIgnore) && fieldSpec.name!= 'createTime' && fieldSpec.name!= 'updateTime' && fieldSpec.type.simpleName=='Date'> ${fieldSpec.name} : new moment(${moduleName}${entityName}?.${camelEntityName}?.${fieldSpec.name} || new Date(), "YYYY-MM-DD HH:mm:ss"),</#if></#list> }
            form.setFieldsValue({ ${camelEntityName}: ${camelEntityName}  });
        }
    },[${moduleName}${entityName}]);

    function handleOk() {
        form
            .validateFields()
            .then(values => {
<#list fieldSpecs as fieldSpec>
    <#if (!fieldSpec.requestDTOIgnore??||!fieldSpec.requestDTOIgnore) && fieldSpec.name!= 'createTime' && fieldSpec.name!= 'updateTime' && fieldSpec.type.simpleName=='Date'>
                values.${camelEntityName}.${fieldSpec.name} = values.${camelEntityName}.${fieldSpec.name}.format('YYYY-MM-DD HH:mm:ss');
    </#if>
</#list>
                if (${moduleName}${entityName}.${camelEntityName}?.id) {
                    values.${camelEntityName}.id = ${moduleName}${entityName}.${camelEntityName}.id;
                    dispatch({
                        type: '${moduleName}${entityName}/update${entityName}',
                        payload: values,
                    });
                } else {
                    dispatch({
                        type: '${moduleName}${entityName}/save${entityName}',
                        payload: values,
                    });
                }
            })
            .catch(err => console.log(err));
    }

    function handleCancel() {
        if (updateLoading || saveLoading) {
            return;
        }
        dispatch({
            type: '${moduleName}${entityName}/set${entityName}',
            payload: { ${camelEntityName}: null },
        });
    }

    return (
        <div>
            <Button type="primary" onClick={()=>show${entityName}Modal()}>新增${displayName}</Button>
            <Modal
                title={(${moduleName}${entityName}?.${camelEntityName}?.id ? '修改' : '新增') + '${displayName}'}
                visible={${moduleName}${entityName}.${camelEntityName} !== null}
                onOk={handleOk}
                maskClosable={false}
                forceRender={true}
                confirmLoading={updateLoading || saveLoading}
                cancelButtonProps={{ disabled: updateLoading || saveLoading }}
                onCancel={handleCancel}
            >
                <Form {...layout} form={form} name="${moduleName}-${camelEntityName}-from">
<#list fieldSpecs as fieldSpec>
   <#if (!fieldSpec.requestDTOIgnore??||!fieldSpec.requestDTOIgnore) && fieldSpec.name!= 'createTime' && fieldSpec.name!= 'updateTime' && fieldSpec.name!= 'id' && fieldSpec.name!= 'deleted'>
                    <Form.Item name={['${camelEntityName}', '${fieldSpec.name}']}
                        label="${fieldSpec.displayName}"
       <#if fieldSpec.type.simpleName =="Boolean">
                        valuePropName = 'checked'
       </#if>
                        rules={[
       <#if fieldSpec.notNull??&&fieldSpec.notNull>
                            { required: true, message: '${fieldSpec.displayName}为必填项！' },
       </#if>
       <#if fieldSpec.maxLength?? && (fieldSpec.type.simpleName== "Long" || fieldSpec.type.simpleName== "Integer" || fieldSpec.type.simpleName== "BigDecimal"|| fieldSpec.type.simpleName== "Byte")>
           <#assign x=fieldSpec.maxLength>
                            { max: <#if (x<19)>1<#list 1..x as i>0</#list><#else>9223372036854775807</#if>, type: "number", message: '${fieldSpec.displayName}不能大于<#if (x<19)>1<#list 1..x as i>0</#list><#else>9223372036854775807</#if>' },
       </#if>
       <#if fieldSpec.minLength?? && (fieldSpec.type.simpleName== "Long" || fieldSpec.type.simpleName== "Integer" || fieldSpec.type.simpleName== "BigDecimal"|| fieldSpec.type.simpleName== "Byte")>
           <#assign x=fieldSpec.maxLength>
                            { min: <#if (x<19)>1<#list 1..x as i>0</#list><#else>9223372036854775807</#if>, type: "number", message: '${fieldSpec.displayName}不能小于<#if (x<19)>1<#list 1..x as i>0</#list><#else>9223372036854775807</#if>' },
       </#if>
       <#if fieldSpec.minLength?? && fieldSpec.type.simpleName= "String">
                            { min: ${fieldSpec.minLength}, message: '${fieldSpec.displayName}不能小于${fieldSpec.minLength}个字符!' },
       </#if>
       <#if fieldSpec.maxLength?? && fieldSpec.type.simpleName= "String">
                            { max: ${fieldSpec.maxLength}, message: '${fieldSpec.displayName}不能大于${fieldSpec.maxLength}个字符!' },
       </#if>
       <#if fieldSpec.regPatten??>
                            { pattern: '${fieldSpec.regPatten}', message: '${fieldSpec.regPattenMessage!(fieldSpec.regPatten+'不符合校验规则!')}' },
       </#if>
                        ]}
                    >
       <#if fieldSpec.type.simpleName== "Long" ||fieldSpec.type.simpleName== "Integer" || fieldSpec.type.simpleName== "BigDecimal"|| fieldSpec.type.simpleName== "Byte">
                        <InputNumber />
           <#elseif fieldSpec.type.simpleName =="Boolean">
                        <Switch />
           <#elseif fieldSpec.type.simpleName =="Date">
                        <DatePicker format="YYYY-MM-DD HH:mm:ss" />
       <#else>
                        <Input />
       </#if>
                    </Form.Item>
   </#if>
</#list>
                </Form>
            </Modal>
        </div>
    );
};

export default connect(({ ${moduleName}${entityName}, loading }) => ({
    ${moduleName}${entityName},
    loading,
}))(${entityName}Modal);
