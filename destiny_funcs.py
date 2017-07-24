def maketime(row):
    '''hack to combine date and PvPEventCount into a single timestamp
    (do this by adding PvPEventCount minutes to each date)'''
    import arrow 
    #return arrow.get(row['date'], 'YYYY-MM-DD').replace(minutes=+row	['PvPEventCount'])
    return arrow.get(row['date'])
    
    
def findspacing(df,n):
    '''find spacing of 1st and nth game'''
    try: 
        start=df[df['game_n']==1]['time'].values
        end=df[df['game_n']==n]['time'].values
        spacing=len(arrow.Arrow.span_range('day',start[0],end[0]))
    except:
        spacing=np.nan
    df['space'+str(n)]=spacing
    return df


    
def ranker(df):
    '''sequential count of total games for each player'''
    import numpy as np
    df['game_n'] = np.arange(len(df)) + 1
    return df  
    
def tagger(df):
    '''label players according to max number of games played etc'''
    df['max_plays'] = max(df['game_n'])
    #find average of top 3 scores for each player on CR and KDR
    df['top_kdr']=df.sort_values(by='killsDeathsRatio', ascending=False)['killsDeathsRatio'][:3].mean()
    df['top_cr_']=df.sort_values(by='combatRating', ascending=False)['combatRating'][:3].mean()
    return df

def savefigfunc(savename,figloc):
    import pylab as plt
    '''save fig in working dir as PNG and in MS directory as EPS'''
    msloc=figloc #manuscript location
    wkloc='figs/'#script development location
    plt.savefig(msloc+savename+'.eps',bbox_inches='tight')
    plt.savefig(wkloc+savename+'.png',bbox_inches='tight')
    print("saving " + savename)



def correlate(var1,var2,plevel):
    '''correlate and find confidence intervals
    assumes variables are pandas df series'''
    import scipy.stats as stats
    psychometric=importr('psychometric') #first run install.packages("psychometric") in R
    mask=~var1.isnull() & ~var2.isnull()
    cor=stats.pearsonr(var1[mask],var2[mask])[0]
    CIs=psychometric.CIr(r=cor, n = len(var1), level = plevel)
    return cor,CIs[0],CIs[1]

def writeresults(string):
    f = open('destiny_results.txt', 'a')
    f.write(string)
    f.write('\n')
    f.close()
