import { update${entityName}, remove${entityName}, save${entityName}, list${entityName} } from '@/services/${moduleName}/${camelEntityName}';
import { DEFAUNT_PAGE_SIZE } from '@/utils/constant';
const ${entityName}Model = {
    namespace: '${moduleName}${entityName}',
    state: {
        list: [],
        total: null,
        current: null,
        ${camelEntityName}: null
    },
    effects: {
        *list({ payload: { page = 1 } }, { call, put }) {
            const response = yield call(list${entityName}, {
                begin: (page - 1) * DEFAUNT_PAGE_SIZE,
                length: DEFAUNT_PAGE_SIZE,
            });
            if (response.result) {
                yield put({
                    type: 'save',
                    payload: { ...response.data },
                });
            }
        },
        *save${entityName}({ payload: { ${camelEntityName} } }, { call, put, select }) {
            const response = yield call(save${entityName}, ${camelEntityName});
            if (response.result) {
                const page = yield select(state => state.${moduleName}${entityName}.current);
                yield put({ type: 'list', payload: { page } });
                yield put({ type: 'set${entityName}', payload: { ${camelEntityName}: null } });
            }
        },
        *update${entityName}({ payload: { ${camelEntityName} } }, { call, put, select }) {
            const response = yield call(update${entityName}, ${camelEntityName});
            if (response.result) {
                const page = yield select(state => state.${moduleName}${entityName}.current);
                yield put({ type: 'list', payload: { page } });
                yield put({ type: 'set${entityName}', payload: { ${camelEntityName}: null } });
            }
        },
        *remove${entityName}({ payload: { id } }, { call, put, select }) {
            const response = yield call(remove${entityName}, [id]);
            if (response.result) {
                const page = yield select(state => state.${moduleName}${entityName}.current);
                yield put({ type: 'list', payload: { page } });
            }
        },
    },
    reducers: {
        save(state, { payload: { list, total, begin, length } }) {
            let current = begin / length + 1;
            return { ...state, list, total, current };
        },
        set${entityName}(state, { payload: { ${camelEntityName} } }) {
            return { ...state, ${camelEntityName} };
        }
    },
    subscriptions: {
        setup({ dispatch, history }) {
            history.listen(({ pathname, query }) => {
                if (pathname === '/${moduleName}/${camelEntityName}s') {
                    dispatch({ type: 'list', payload: query });
                }
            });
        },
    },
};
export default ${entityName}Model;