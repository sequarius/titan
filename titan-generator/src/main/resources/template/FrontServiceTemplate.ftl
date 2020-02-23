import request from '@/utils/request';

export async function list${entityName}({ begin, length }) {
    return request(`/api${url!('/'+moduleName+'/'+camelEntityName)}s?begin=${r'${begin}'}&length=${r'${length}'}`, { showMessage: false });
}

export async function save${entityName}(${camelEntityName}) {
    return request('/api${url!('/'+moduleName+'/'+camelEntityName)}', { method: 'POST', data: ${camelEntityName} });
}

export async function update${entityName}(${camelEntityName}) {
    return request('/api${url!('/'+moduleName+'/'+camelEntityName)}', { method: 'PUT', data: ${camelEntityName} });
}

export async function remove${entityName}(ids) {
    return request('/api${url!('/'+moduleName+'/'+camelEntityName)}', { method: 'DELETE', data: ids });
}
