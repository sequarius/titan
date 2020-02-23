import { PageHeaderWrapper } from '@ant-design/pro-layout';
import React from 'react';
import ${entityName}Table from './components/${entityName}Table';
import { connect } from 'dva';

const ${entityName}Page = ({ ${moduleName}${entityName} }) => {
    return (
        <PageHeaderWrapper
        >
            <${entityName}Table />
        </PageHeaderWrapper>
    );
};

export default connect(({ ${moduleName}${entityName} }) => ({
    ${moduleName}${entityName},
}))(${entityName}Page);
