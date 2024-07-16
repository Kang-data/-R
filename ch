import pandas as pd
import numpy as np

# 예제 데이터 dict 생성
data = {
    'C_MIN': [np.nan, np.nan, 0, np.nan, np.nan, np.nan, 0, np.nan, np.nan, np.nan, np.nan, np.nan],
    'C_MAX': [np.nan, 0.1, 0.2, 0.02, np.nan, np.nan, 0.1, np.nan, np.nan, np.nan, np.nan, np.nan],
    'C_AIM': [0.2, 0.1, np.nan, 0.1, 0.03, np.nan, np.nan, np.nan, 0.04, 0.06, np.nan, 0.2],
    'Fe_MIN': [np.nan, 0.01, np.nan, np.nan, np.nan, 0.4, np.nan, 0.02, 0.01, 0.2, 0.01, 0.01],
    'Fe_MAX': [0.1, np.nan, 0.2, 0.3, 0.02, np.nan, 0.3, np.nan, np.nan, np.nan, np.nan, np.nan]
}

# dict를 DataFrame으로 변환
df = pd.DataFrame(data)

# DataFrame 출력
df

##############################################################################

def null_imputation(df):
    min_cols = (col for col in df.columns if "MIN" in col)
    max_cols = (col for col in df.columns if "MAX" in col)

    for min_col, max_col in zip(min_cols, max_cols):
        element = min_col.split("_")[0]
        aim_col = f"{element}_AIM"

        if aim_col in df.columns :#aim_col 이 존재한는 case1, case2, case5
            for i in range(len(df)):
                # case1: _MIN이 null이고 _MAX도 null이며 _AIM이 존재할 경우
                if pd.isna(df.loc[i, min_col]) and pd.isna(df.loc[i, max_col]) and pd.notna(df.loc[i, aim_col]):
                    df.loc[i, min_col] = df.loc[i, aim_col]
                    df.loc[i, max_col] = df.loc[i, aim_col]
   
                #case2 : case2   min : o   max : o  aim : null
                elif pd.notna(df.loc[i, min_col]) and pd.notna(df.loc[i, max_col]) and pd.isna(df.loc[i, aim_col]):
                    continue  # 아무 작업도 하지 않음
                
                #case5 : min : null   max : null  aim : null
                elif pd.isna(df.loc[i, min_col]) and pd.isna(df.loc[i, max_col]) and pd.isna(df.loc[i, aim_col]):
                    max_value_len = df[max_col].dropna().astype(str).map(len).max()
                    df.loc[i, min_col] = 0
                    df.loc[i, max_col] = max_value_len # 최대 단위
                
                #case6 : min : null max : o aim : o
                elif pd.isna(df.loc[i, min_col]) and pd.notna(df.loc[i, max_col]) and pd.notna(df.loc[i, aim_col]):
                    df.loc[i, min_col] = df.loc[i, aim_col]


        elif aim_col not in df.columns : #aim_col 이 없는 case3, case4 ##?? 왜(aim_col in df.columns == False) 안되는건가
            for i in range(len(df)):
                # case3: _MIN이 null이고 _MAX는 존재하며 _AIM이 null일 경우
                if pd.isna(df.loc[i, min_col]) and pd.notna(df.loc[i, max_col]) :
                    df.loc[i, min_col] = 0

                # case4 : _MIN이 null이고 _MAX는 존재하며 _AIM이 null일 경우 (case3와 동일)
                elif pd.isna(df.loc[i, min_col]) and pd.notna(df.loc[i, max_col]) :
                    df.loc[i, min_col] = 0
        
        
            
        
    return df

df_filled = null_imputation(df)
df_filled
