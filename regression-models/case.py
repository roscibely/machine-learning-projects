# -*- coding: utf-8 -*-
'''
Problema: Um cliente que atua no setor alimentício na cidade do Rio
de Janeiro gostaria de entender melhor sobre o seu público alvo. Dadas
as variáveis sociodemográficas (presentes no dicionário de dados) e a
variável de performance faturamento, realize uma análise exploratória
trazendo insights sobre o público alvo da rede e crie um modelo de
regressão capaz de prever o faturamento em novos bairros, caso o
nosso cliente queira realizar um projeto de expansão.
'''

#1. Libraries e frameworks necessários
import pandas as pd                       
import matplotlib.pyplot as plt
import seaborn as sns
import scipy.stats as st
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor

# 2. Leitura dos dados
df = pd.read_csv('dataset.csv')
df.head()

# 3. Alguns insights sobre o público alvo
local_vs_faturamento= df.groupby(['faturamento','nome'], as_index=False)['faturamento'].max()
plt.rcdefaults()
fig, ax = plt.subplots()
ax.barh(local_vs_faturamento['nome'].values[130:160],local_vs_faturamento['faturamento'].values[130:160], align='center')
ax.set_xlabel('Faturamento (R$)')
ax.set_title('Os 30 bairros que apresentam maior faturamento')
ax.grid(True)
plt.show()

plt.rcdefaults()
fig, ax = plt.subplots()
ax.barh(local_vs_faturamento['nome'].values[0:30],local_vs_faturamento['faturamento'].values[0:30], align='center')
ax.set_title('Os 30 bairros que apresentam um menor faturamento')
ax.set_xlabel('Faturamento (R$)')
ax.grid(True)
plt.show()

publico=df.groupby(['popAte9','popDe10a14', 'popDe15a19', 'popDe20a24', 'popDe25a34', 'popDe35a49', 'popDe50a59', 'popMaisDe60'], as_index=False)['população'].agg('sum')
width = 0.15  
fig, ax = plt.subplots()
x=np.arange(1)
ax.bar(0.5, publico['popAte9'].sum(), width, label='Até 9 anos')
ax.bar(1, publico['popDe10a14'].sum(), width, label='15-19 anos')
ax.bar(1.5, publico['popDe20a24'].sum(), width, label='20-24 anos')
ax.bar(2, publico['popDe25a34'].sum(), width, label='25-34 anos')
ax.bar(2.5, publico['popDe35a49'].sum(), width, label='35-49 anos')
ax.bar(3, publico['popDe50a59'].sum(), width, label='50-59 anos')
ax.bar(3.5, publico['popMaisDe60'].sum(), width, label='Mais de 60 anos')
ax.set_ylabel('População')
ax.set_title('Público alvo')
ax.legend(loc='best')
ax.grid(True)

fig = plt.figure()
ax = fig.add_axes([0,0,1,1])
ax.axis('equal')
a1=df[['domiciliosA1', 'domiciliosA2',	'domiciliosB1',	'domiciliosB2',	'domiciliosC1',	'domiciliosC2',	'domiciliosD',	'domiciliosE']].sum()
houses = a1.values
ax.pie(houses, labels= ['A1', 'A2', 'B1', 'B2', 'C1', 'C2', 'D', 'E'],autopct='%1.2f%%')
plt.title('Porcentagem de domicílios')
plt.show()

# 4. Modelos de regressão
x= df[['codigo', 'população', 'domiciliosA1', 'domiciliosA2',	'domiciliosB1',	'domiciliosB2',	'domiciliosC1',	'domiciliosC2',	'domiciliosD',	'domiciliosE']]
y = df['faturamento'].values                    # Consider the labels as the neighborhood's total revenue 
sns.distplot(tuple(y), kde=True, fit=st.norm)   # Label distribution
plt.show()

x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.2, random_state=20) # Segment the data.
ss = StandardScaler()                                                                     # Standardize the data set.
x_train = ss.fit_transform(x_train)
x_test = ss.transform(x_test)

model_GBDT = GradientBoostingRegressor(n_estimators=30)
model_GBDT.fit(x_train, y_train)
model_RFR=RandomForestRegressor(n_estimators=10)
model_RFR.fit(x_train, y_train)
model_LR= LinearRegression()
model_LR.fit(x_train, y_train)

# Perform visualization.
ln_x_test = range(len(x_test))
y_predict_GBDT = model_GBDT.predict(x_test)
y_predict_RFR = model_RFR.predict(x_test)
y_predict_LR = model_LR.predict(x_test)

plt.figure(figsize=(16,8), facecolor='w')
plt.plot (ln_x_test, y_test, 'k-', lw=2, label=u'Faturamento real')
plt.plot (ln_x_test, y_predict_GBDT, 'm--', lw = 3, label=u'Faturamento predito - GBDT')
plt.plot (ln_x_test, y_predict_RFR, 'c:', lw = 3, label=u'Faturamento predito - RFR')
plt.plot (ln_x_test, y_predict_LR, 'y-.', lw = 3, label=u'Faturamento predito - LR')
plt.ylabel('Faturamento (R$)')

# Display 
plt.legend(loc ='upper left')
plt.grid(True)
plt.title(u"Modelos de Regressão")
plt.show()
